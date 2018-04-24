module kiss.event.timer.kqueue;

import kiss.core;

// dfmt off
version (Kqueue) : 
// dfmt on

import kiss.event.core;
import kiss.event.timer.common;
import kiss.timingwheel;
import kiss.event.watcher;

import core.stdc.errno;
import core.sys.posix.sys.types; // for ssize_t, size_t
import core.sys.posix.netinet.tcp;
import core.sys.posix.netinet.in_;
import core.sys.posix.time;
import core.sys.posix.unistd;

import std.exception;
import std.socket;

/**
*/
class KqueueTimer : TimerChannelBase
{
   this()
    {
        super();
        setFlag(WatchFlag.Read,true);
        _sock = new Socket(AddressFamily.UNIX,SocketType.STREAM);
        this.handle = _sock.handle;
        _readBuffer = new UintObject();
    }

    ~this(){
        close();
    }

    // int fd(){return _sock.handle;}

    bool readTimer(scope ReadCallBack read)
    {
        this.clearError();
        this._readBuffer.data = 1;
        if(read)
            read(this._readBuffer);
        return false;
    }

    UintObject _readBuffer;
    Socket _sock;
}
