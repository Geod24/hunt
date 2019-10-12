module hunt.io.channel.iocp.AbstractStream;

// dfmt off
version (HAVE_IOCP) : 
// dfmt on

import hunt.collection.ByteBuffer;
import hunt.collection.BufferUtils;
import hunt.event.selector.Selector;
import hunt.io.channel.AbstractSocketChannel;
import hunt.io.channel.Common;
import hunt.io.channel.iocp.Common;
import hunt.logging.ConsoleLogger;
import hunt.Functions;
import hunt.concurrency.thread.Helper;

import core.atomic;
import core.sys.windows.windows;
import core.sys.windows.winsock2;
import core.sys.windows.mswsock;

import std.format;
import std.socket;


/**
TCP Peer
*/
abstract class AbstractStream : AbstractSocketChannel {

    // data event handlers
    
    /**
    * Warning: The received data is stored a inner buffer. For a data safe, 
    * you would make a copy of it. 
    */
    protected DataReceivedHandler dataReceivedHandler;
    protected SimpleActionHandler dataWriteDoneHandler;

    protected AddressFamily _family;
    protected ByteBuffer _bufferForRead;

    this(Selector loop, AddressFamily family = AddressFamily.INET, size_t bufferSize = 4096 * 2) {
        super(loop, ChannelType.TCP);
        // setFlag(ChannelFlag.Read, true);
        // setFlag(ChannelFlag.Write, true);

        version (HUNT_IO_DEBUG)
            trace("Buffer size for read: ", bufferSize);
        // _readBuffer = new ubyte[bufferSize];
        
        _bufferForRead = BufferUtils.allocate(bufferSize);
        _bufferForRead.clear();
        _readBuffer = cast(ubyte[])_bufferForRead.array();
        _writeQueue = new WritingBufferQueue();
        this.socket = new TcpSocket(family);

        loadWinsockExtension(this.handle);
    }

    mixin CheckIocpError;

    override void onRead() {
        version (HUNT_IO_DEBUG)
            trace("ready to read");
        super.onRead();
    }

    /**
     * Should be thread-safe.
     */
    override void onWrite() {  
        version (HUNT_IO_DEBUG)
            tracef("checking write status, isWritting: %s, writeBuffer: %s", _isWritting, writeBuffer is null);

        if(!_isWritting){
            version (HUNT_IO_DEBUG) infof("No data to write out. fd=%d", this.handle);
            return;
        }

        if(isClosing() && isWriteCancelling) {
            version (HUNT_IO_DEBUG) infof("Write cancelled, fd=%d", this.handle);
            resetWriteStatus();
            return;
        }

        tryNextBufferWrite();
    }
    
    protected override void onClose() {
        _isWritting = false;

        if(this._socket is null) {
            import core.sys.windows.winsock2;
            .closesocket(this.handle);
        } else {
            // FIXME: Needing refactor or cleanup -@Administrator at 2019/8/9 1:20:27 pm
            // 
            infof("socket closed: fd=%d ", this.handle);
            // this._socket.shutdown(SocketShutdown.BOTH);
            // this._socket.close();
        }
        super.onClose();
    }

    protected void beginRead() {
        WSABUF _dataReadBuffer;
        _dataReadBuffer.len = cast(uint) _readBuffer.length;
        _dataReadBuffer.buf = cast(char*) _readBuffer.ptr;
        _iocpread.channel = this;
        _iocpread.operation = IocpOperation.read;
        DWORD dwReceived = 0;
        DWORD dwFlags = 0;

        version (HUNT_IO_DEBUG)
            tracef("start receiving [fd=%d] ", this.socket.handle);

        // https://docs.microsoft.com/en-us/windows/desktop/api/winsock2/nf-winsock2-wsarecv
        int nRet = WSARecv(cast(SOCKET) this.socket.handle, &_dataReadBuffer, 1u, &dwReceived, &dwFlags,
                &_iocpread.overlapped, cast(LPWSAOVERLAPPED_COMPLETION_ROUTINE) null);

        checkErro(nRet, SOCKET_ERROR);
    }

    protected void doConnect(Address addr) {
        Address binded = createAddress(this.socket.addressFamily);
        this.socket.bind(binded);
        _iocpwrite.channel = this;
        _iocpwrite.operation = IocpOperation.connect;
        int nRet = ConnectEx(cast(SOCKET) this.socket.handle(),
                cast(SOCKADDR*) addr.name(), addr.nameLen(), null, 0, null,
                &_iocpwrite.overlapped);
        checkErro(nRet, SOCKET_ERROR);
    }

    private uint doWrite(const(ubyte)[] data) {
        DWORD dwFlags = 0;
        DWORD dwSent = 0;
        _iocpwrite.channel = this;
        _iocpwrite.operation = IocpOperation.write;
        // tracef("To write %d bytes, fd=%d", data.length, this.socket.handle());
        version (HUNT_IO_DEBUG) {
            size_t bufferLength = data.length;
            tracef("To write %d bytes, fd=%d", bufferLength, this.socket.handle());
            if (bufferLength > 32)
                tracef("%(%02X %) ...", data[0 .. 32]);
            else
                tracef("%(%02X %)", data[0 .. $]);
        }

        WSABUF _dataWriteBuffer;

        _dataWriteBuffer.buf = cast(char*) data.ptr;
        _dataWriteBuffer.len = cast(uint) data.length;
        int nRet = WSASend(cast(SOCKET) this.socket.handle(), &_dataWriteBuffer, 1, &dwSent,
                dwFlags, &_iocpwrite.overlapped, cast(LPWSAOVERLAPPED_COMPLETION_ROUTINE) null);

        // FIXME: Needing refactor or cleanup -@Administrator at 2019/8/9 12:18:20 pm
        // Keep this to prevent the buffer corrupted. Why?
        version (HUNT_IO_DEBUG) {
            tracef("sent: %d / %d bytes, fd=%d", dwSent, bufferLength, this.handle);
        }

        checkErro(nRet, SOCKET_ERROR);

        if (this.isError) {
            errorf("Socket error on write: fd=%d, message=%s", this.handle, this.erroString);
            this.close();
        }

        return dwSent;
    }

    protected void doRead() {
        this.clearError();
        version (HUNT_IO_DEBUG)
            tracef("start reading: %d nbytes", this.readLen);

        if (readLen > 0) {
            // import std.stdio;
            // writefln("length=%d, data: %(%02X %)", readLen, _readBuffer[0 .. readLen]);
            version (HUNT_IO_DEBUG)
                tracef("reading done: %d nbytes", readLen);

            if (dataReceivedHandler !is null) {
                _bufferForRead.limit(cast(int)readLen);
                _bufferForRead.position(0);
                dataReceivedHandler(_bufferForRead);
            }

            // continue reading
            this.beginRead();
        } else if (readLen == 0) {
            version (HUNT_IO_DEBUG) {
                if (_remoteAddress !is null)
                    warningf("connection broken: %s", _remoteAddress.toString());
            }
            onDisconnected();
            // if (_isClosed)
            //     this.close();
        } else {
            version (HUNT_IO_DEBUG) {
                warningf("undefined behavior on thread %d", getTid());
            } else {
                this._error = true;
                this._erroString = "undefined behavior on thread";
            }
        }
    }

    // try to write a block of data directly
    protected size_t tryWrite(const ubyte[] data) {        
        version (HUNT_IO_DEBUG)
            tracef("start to write, total=%d bytes, fd=%d", data.length, this.handle);
        clearError();
        size_t nBytes = doWrite(data);

        return nBytes;
    }

    // try to write a block of data from the write queue
    private void tryNextBufferWrite() {
        if(checkAllWriteDone()){
            return;
        } 
        
        // keep thread-safe here
        if(!cas(&_isSingleWriteBusy, false, true)) {
            version (HUNT_IO_DEBUG) warningf("busy writing. fd=%d", this.handle);
            return;
        }

        scope(exit) {
            _isSingleWriteBusy = false;
        }

        clearError();

        bool haveBuffer = _writeQueue.tryDequeue(writeBuffer);
        if(haveBuffer) {
            writeBufferRemaining();
        } else {
            version (HUNT_IO_DEBUG)
                warning("No buffer in queue");
        }
    }

    private void writeBufferRemaining() {

        const(ubyte)[] data = cast(const(ubyte)[])writeBuffer.getRemaining();
        size_t nBytes = doWrite(data);

        version (HUNT_IO_DEBUG)
            tracef("written data: %d bytes, fd=%d", nBytes, this.handle);
        if(nBytes == data.length) {
            writeBuffer = null;
        } else if (nBytes > 0) { 
            writeBuffer.nextGetIndex(cast(int)nBytes);
            version (HUNT_IO_DEBUG)
                warningf("remaining data: %d / %d, fd=%d", data.length - nBytes, data.length, this.handle);
        } else { 
            version (HUNT_IO_DEBUG)
            warningf("I/O busy: writing. fd=%d", this.handle);
        }   
    }
    
    protected bool checkAllWriteDone() {
        if(_writeQueue.isEmpty()) {
            resetWriteStatus();        
            version (HUNT_IO_DEBUG)
                tracef("All data are written out. fd=%d", this.handle);
            if(dataWriteDoneHandler !is null)
                dataWriteDoneHandler(this);
            return true;
        }

        return false;
    }
    
    void resetWriteStatus() {
        _writeQueue.clear();
        _isWritting = false;
        isWriteCancelling = false;
        sendDataBuffer = null;
        sendDataBackupBuffer = null;
    }

    /**
     * Called by selector after data sent
     * Note: It's only for IOCP selector: 
    */
    void onWriteDone(size_t nBytes) {
        version (HUNT_IO_DEBUG) {
            tracef("write done once: %d bytes, isWritting: %s, writeBuffer: %s, fd=%d",
                 nBytes, _isWritting, writeBuffer is null, this.handle);
        }

        if (isWriteCancelling) {
            version (HUNT_IO_DEBUG) tracef("write cancelled.");
            resetWriteStatus();
            return;
        }

        while(_isSingleWriteBusy) {
            // version(HUNT_IO_DEBUG) 
            info("waiting for last writting get finished...");
        }

        version (HUNT_IO_DEBUG) {
            tracef("write done once: %d bytes, isWritting: %s, writeBuffer: %s, fd=%d",
                 nBytes, _isWritting, writeBuffer is null, this.handle);
        }

        if (writeBuffer !is null && writeBuffer.hasRemaining()) {
            version (HUNT_IO_DEBUG) tracef("try to write the remaining in buffer.");
            writeBufferRemaining();
        }  else {
            version (HUNT_IO_DEBUG) tracef("try to write next buffer.");
            tryNextBufferWrite();
        }
    }

    private void notifyDataWrittenDone() {
        if(dataWriteDoneHandler !is null && _writeQueue.isEmpty()) {
            dataWriteDoneHandler(this);
        }
    }

    void cancelWrite() {
        isWriteCancelling = true;
    }

    abstract bool isConnected() nothrow;
    abstract protected void onDisconnected();

    // protected void initializeWriteQueue() {
    //     if (_writeQueue is null) {
    //         _writeQueue = new WritingBufferQueue();
    //     }
    // }

    SimpleEventHandler disconnectionHandler;
    
    protected WritingBufferQueue _writeQueue;
    protected bool isWriteCancelling = false;
    private shared bool _isSingleWriteBusy = false; // keep a single I/O write operation atomic
    private const(ubyte)[] _readBuffer;
    private const(ubyte)[] sendDataBuffer;
    private const(ubyte)[] sendDataBackupBuffer;
    private ByteBuffer writeBuffer; 

    private IocpContext _iocpread;
    private IocpContext _iocpwrite;
}
