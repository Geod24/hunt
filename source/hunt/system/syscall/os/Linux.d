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

module hunt.system.syscall.os.Linux;

version(linux):

enum __NR_read = 0;
enum __NR_write = 1;
enum __NR_open = 2;
enum __NR_close = 3;
enum __NR_stat = 4;
enum __NR_fstat = 5;
enum __NR_lstat = 6;
enum __NR_poll = 7;
enum __NR_lseek = 8;
enum __NR_mmap = 9;
enum __NR_mprotect = 10;
enum __NR_munmap = 11;
enum __NR_brk = 12;
enum __NR_rt_sigaction = 13;
enum __NR_rt_sigprocmask = 14;
enum __NR_rt_sigreturn = 15;
enum __NR_ioctl = 16;
enum __NR_pread64 = 17;
enum __NR_pwrite64 = 18;
enum __NR_readv = 19;
enum __NR_writev = 20;
enum __NR_access = 21;
enum __NR_pipe = 22;
enum __NR_select = 23;
enum __NR_sched_yield = 24;
enum __NR_mremap = 25;
enum __NR_msync = 26;
enum __NR_mincore = 27;
enum __NR_madvise = 28;
enum __NR_shmget = 29;
enum __NR_shmat = 30;
enum __NR_shmctl = 31;
enum __NR_dup = 32;
enum __NR_dup2 = 33;
enum __NR_pause = 34;
enum __NR_nanosleep = 35;
enum __NR_getitimer = 36;
enum __NR_alarm = 37;
enum __NR_setitimer = 38;
enum __NR_getpid = 39;
enum __NR_sendfile = 40;
enum __NR_socket = 41;
enum __NR_connect = 42;
enum __NR_accept = 43;
enum __NR_sendto = 44;
enum __NR_recvfrom = 45;
enum __NR_sendmsg = 46;
enum __NR_recvmsg = 47;
enum __NR_shutdown = 48;
enum __NR_bind = 49;
enum __NR_listen = 50;
enum __NR_getsockname = 51;
enum __NR_getpeername = 52;
enum __NR_socketpair = 53;
enum __NR_setsockopt = 54;
enum __NR_getsockopt = 55;
enum __NR_clone = 56;
enum __NR_fork = 57;
enum __NR_vfork = 58;
enum __NR_execve = 59;
enum __NR_exit = 60;
enum __NR_wait4 = 61;
enum __NR_kill = 62;
enum __NR_uname = 63;
enum __NR_semget = 64;
enum __NR_semop = 65;
enum __NR_semctl = 66;
enum __NR_shmdt = 67;
enum __NR_msgget = 68;
enum __NR_msgsnd = 69;
enum __NR_msgrcv = 70;
enum __NR_msgctl = 71;
enum __NR_fcntl = 72;
enum __NR_flock = 73;
enum __NR_fsync = 74;
enum __NR_fdatasync = 75;
enum __NR_truncate = 76;
enum __NR_ftruncate = 77;
enum __NR_getdents = 78;
enum __NR_getcwd = 79;
enum __NR_chdir = 80;
enum __NR_fchdir = 81;
enum __NR_rename = 82;
enum __NR_mkdir = 83;
enum __NR_rmdir = 84;
enum __NR_creat = 85;
enum __NR_link = 86;
enum __NR_unlink = 87;
enum __NR_symlink = 88;
enum __NR_readlink = 89;
enum __NR_chmod = 90;
enum __NR_fchmod = 91;
enum __NR_chown = 92;
enum __NR_fchown = 93;
enum __NR_lchown = 94;
enum __NR_umask = 95;
enum __NR_gettimeofday = 96;
enum __NR_getrlimit = 97;
enum __NR_getrusage = 98;
enum __NR_sysinfo = 99;
enum __NR_times = 100;
enum __NR_ptrace = 101;
enum __NR_getuid = 102;
enum __NR_syslog = 103;
enum __NR_getgid = 104;
enum __NR_setuid = 105;
enum __NR_setgid = 106;
enum __NR_geteuid = 107;
enum __NR_getegid = 108;
enum __NR_setpgid = 109;
enum __NR_getppid = 110;
enum __NR_getpgrp = 111;
enum __NR_setsid = 112;
enum __NR_setreuid = 113;
enum __NR_setregid = 114;
enum __NR_getgroups = 115;
enum __NR_setgroups = 116;
enum __NR_setresuid = 117;
enum __NR_getresuid = 118;
enum __NR_setresgid = 119;
enum __NR_getresgid = 120;
enum __NR_getpgid = 121;
enum __NR_setfsuid = 122;
enum __NR_setfsgid = 123;
enum __NR_getsid = 124;
enum __NR_capget = 125;
enum __NR_capset = 126;
enum __NR_rt_sigpending = 127;
enum __NR_rt_sigtimedwait = 128;
enum __NR_rt_sigqueueinfo = 129;
enum __NR_rt_sigsuspend = 130;
enum __NR_sigaltstack = 131;
enum __NR_utime = 132;
enum __NR_mknod = 133;
enum __NR_uselib = 134;
enum __NR_personality = 135;
enum __NR_ustat = 136;
enum __NR_statfs = 137;
enum __NR_fstatfs = 138;
enum __NR_sysfs = 139;
enum __NR_getpriority = 140;
enum __NR_setpriority = 141;
enum __NR_sched_setparam = 142;
enum __NR_sched_getparam = 143;
enum __NR_sched_setscheduler = 144;
enum __NR_sched_getscheduler = 145;
enum __NR_sched_get_priority_max = 146;
enum __NR_sched_get_priority_min = 147;
enum __NR_sched_rr_get_interval = 148;
enum __NR_mlock = 149;
enum __NR_munlock = 150;
enum __NR_mlockall = 151;
enum __NR_munlockall = 152;
enum __NR_vhangup = 153;
enum __NR_modify_ldt = 154;
enum __NR_pivot_root = 155;
enum __NR__sysctl = 156;
enum __NR_prctl = 157;
enum __NR_arch_prctl = 158;
enum __NR_adjtimex = 159;
enum __NR_setrlimit = 160;
enum __NR_chroot = 161;
enum __NR_sync = 162;
enum __NR_acct = 163;
enum __NR_settimeofday = 164;
enum __NR_mount = 165;
enum __NR_umount2 = 166;
enum __NR_swapon = 167;
enum __NR_swapoff = 168;
enum __NR_reboot = 169;
enum __NR_sethostname = 170;
enum __NR_setdomainname = 171;
enum __NR_iopl = 172;
enum __NR_ioperm = 173;
enum __NR_create_module = 174;
enum __NR_init_module = 175;
enum __NR_delete_module = 176;
enum __NR_get_kernel_syms = 177;
enum __NR_query_module = 178;
enum __NR_quotactl = 179;
enum __NR_nfsservctl = 180;
enum __NR_getpmsg = 181;
enum __NR_putpmsg = 182;
enum __NR_afs_syscall = 183;
enum __NR_tuxcall = 184;
enum __NR_security = 185;
enum __NR_gettid = 186;
enum __NR_readahead = 187;
enum __NR_setxattr = 188;
enum __NR_lsetxattr = 189;
enum __NR_fsetxattr = 190;
enum __NR_getxattr = 191;
enum __NR_lgetxattr = 192;
enum __NR_fgetxattr = 193;
enum __NR_listxattr = 194;
enum __NR_llistxattr = 195;
enum __NR_flistxattr = 196;
enum __NR_removexattr = 197;
enum __NR_lremovexattr = 198;
enum __NR_fremovexattr = 199;
enum __NR_tkill = 200;
enum __NR_time = 201;
enum __NR_futex = 202;
enum __NR_sched_setaffinity = 203;
enum __NR_sched_getaffinity = 204;
enum __NR_set_thread_area = 205;
enum __NR_io_setup = 206;
enum __NR_io_destroy = 207;
enum __NR_io_getevents = 208;
enum __NR_io_submit = 209;
enum __NR_io_cancel = 210;
enum __NR_get_thread_area = 211;
enum __NR_lookup_dcookie = 212;
enum __NR_epoll_create = 213;
enum __NR_epoll_ctl_old = 214;
enum __NR_epoll_wait_old = 215;
enum __NR_remap_file_pages = 216;
enum __NR_getdents64 = 217;
enum __NR_set_tid_address = 218;
enum __NR_restart_syscall = 219;
enum __NR_semtimedop = 220;
enum __NR_fadvise64 = 221;
enum __NR_timer_create = 222;
enum __NR_timer_settime = 223;
enum __NR_timer_gettime = 224;
enum __NR_timer_getoverrun = 225;
enum __NR_timer_delete = 226;
enum __NR_clock_settime = 227;
enum __NR_clock_gettime = 228;
enum __NR_clock_getres = 229;
enum __NR_clock_nanosleep = 230;
enum __NR_exit_group = 231;
enum __NR_epoll_wait = 232;
enum __NR_epoll_ctl = 233;
enum __NR_tgkill = 234;
enum __NR_utimes = 235;
enum __NR_vserver = 236;
enum __NR_mbind = 237;
enum __NR_set_mempolicy = 238;
enum __NR_get_mempolicy = 239;
enum __NR_mq_open = 240;
enum __NR_mq_unlink = 241;
enum __NR_mq_timedsend = 242;
enum __NR_mq_timedreceive = 243;
enum __NR_mq_notify = 244;
enum __NR_mq_getsetattr = 245;
enum __NR_kexec_load = 246;
enum __NR_waitid = 247;
enum __NR_add_key = 248;
enum __NR_request_key = 249;
enum __NR_keyctl = 250;
enum __NR_ioprio_set = 251;
enum __NR_ioprio_get = 252;
enum __NR_inotify_init = 253;
enum __NR_inotify_add_watch = 254;
enum __NR_inotify_rm_watch = 255;
enum __NR_migrate_pages = 256;
enum __NR_openat = 257;
enum __NR_mkdirat = 258;
enum __NR_mknodat = 259;
enum __NR_fchownat = 260;
enum __NR_futimesat = 261;
enum __NR_newfstatat = 262;
enum __NR_unlinkat = 263;
enum __NR_renameat = 264;
enum __NR_linkat = 265;
enum __NR_symlinkat = 266;
enum __NR_readlinkat = 267;
enum __NR_fchmodat = 268;
enum __NR_faccessat = 269;
enum __NR_pselect6 = 270;
enum __NR_ppoll = 271;
enum __NR_unshare = 272;
enum __NR_set_robust_list = 273;
enum __NR_get_robust_list = 274;
enum __NR_splice = 275;
enum __NR_tee = 276;
enum __NR_sync_file_range = 277;
enum __NR_vmsplice = 278;
enum __NR_move_pages = 279;
enum __NR_utimensat = 280;
enum __NR_epoll_pwait = 281;
enum __NR_signalfd = 282;
enum __NR_timerfd_create = 283;
enum __NR_eventfd = 284;
enum __NR_fallocate = 285;
enum __NR_timerfd_settime = 286;
enum __NR_timerfd_gettime = 287;
enum __NR_accept4 = 288;
enum __NR_signalfd4 = 289;
enum __NR_eventfd2 = 290;
enum __NR_epoll_create1 = 291;
enum __NR_dup3 = 292;
enum __NR_pipe2 = 293;
enum __NR_inotify_init1 = 294;
enum __NR_preadv = 295;
enum __NR_pwritev = 296;
enum __NR_rt_tgsigqueueinfo = 297;
enum __NR_perf_event_open = 298;
enum __NR_recvmmsg = 299;
enum __NR_fanotify_init = 300;
enum __NR_fanotify_mark = 301;
enum __NR_prlimit64 = 302;
enum __NR_name_to_handle_at = 303;
enum __NR_open_by_handle_at = 304;
enum __NR_clock_adjtime = 305;
enum __NR_syncfs = 306;
enum __NR_sendmmsg = 307;
enum __NR_setns = 308;
enum __NR_getcpu = 309;
enum __NR_process_vm_readv = 310;
enum __NR_process_vm_writev = 311;
enum __NR_kcmp = 312;
enum __NR_finit_module = 313;
enum __NR_sched_setattr = 314;
enum __NR_sched_getattr = 315;
enum __NR_renameat2 = 316;
enum __NR_seccomp = 317;
enum __NR_getrandom = 318;
enum __NR_memfd_create = 319;
enum __NR_kexec_file_load = 320;
enum __NR_bpf = 321;
enum __NR_execveat = 322;
enum __NR_userfaultfd = 323;
enum __NR_membarrier = 324;
enum __NR_mlock2 = 325;
enum __NR_copy_file_range = 326;
enum __NR_preadv2 = 327;
enum __NR_pwritev2 = 328;
enum __NR_pkey_mprotect = 329;
enum __NR_pkey_alloc = 330;
enum __NR_pkey_free = 331;
enum __NR_statx = 332;

