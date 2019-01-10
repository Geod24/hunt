/*
 * Hunt - A refined core library for D programming language.
 *
 * Copyright (C) 2018-2019 HuntLabs
 *
 * Website: https://www.huntlabs.net/
 *
 * Licensed under the Apache-2.0 License.
 *
 */

module hunt.system.Error;

import core.stdc.string;

version (Windows) {
    import core.sys.windows.winnt;
    /// https://docs.microsoft.com/zh-cn/windows/desktop/Intl/language-identifier-constants-and-strings
    string getErrorMessage(bool useStdC = false)(int errno, int langId = LANG_ENGLISH) @trusted {

        static if (useStdC) {
            auto s = strerror(errno);
            return s[0 .. s.strlen].idup;
        } else {
            import std.windows.syserror;

            return sysErrorString(errno, langId);
        }
    }
} else {
    string getErrorMessage(int errno) @trusted {
        version (Posix) {
            import core.stdc.errno;
            import std.conv: to;

            char[80] buf;
            const(char)* cs;
            version (CRuntime_Glibc) {
                cs = strerror_r(errno, buf.ptr, buf.length);
            } else {
                auto errs = strerror_r(errno, buf.ptr, buf.length);
                if (errs == 0)
                    cs = buf.ptr;
                else
                    return to!string(errno);
            }

            auto len = strlen(cs);

            if (cs[len - 1] == '\n')
                len--;
            if (cs[len - 1] == '\r')
                len--;
            return cs[0 .. len].idup;
        } else {
            auto s = strerror(errno);
            return s[0 .. s.strlen].idup;
        }
    }
}
