extern Main { ... -- ret }

extern Abort { ... fmt -- }

extern Create { path mode pbits -- fd }

extern Open { path mode -- fd }

extern Close { fd -- ok }

extern Write { buf len fd -- bytes }

extern Read { buf len fd -- bytes }

extern Spawn { ... path -- pid }

extern VSpawn { argcn argvt path -- pid }

extern SSpawn { ... fd0 fd1 fd2 path -- pid }

extern ASpawn { fd0 fd1 fd2 argcn argvt path -- pid }

extern Exit { ret -- }

extern FDup { fd1 -- fd2 }

extern SetTTYIgnore { ign -- ok }

extern Readline { s max -- eof }

extern NewProcess { path fd0 fd1 fd2 mode udatavec udatac -- pid }

extern Wait { -- pid ret }

extern SetUID { uid -- ok }

extern GetPID { -- pid }

extern GetUID { -- uid }

extern GetEUID { -- euid }

extern ReadDir { dirent fd -- ok }

extern PStat { stat path -- ok }

extern FStat { stat fd -- ok }

extern Chdir { path -- ok }

extern UName { uname -- ok }

extern Unlink { path -- ok }

extern Mkdir { path mode -- ok }

extern UMask { umask -- old }

extern Mount { flags dev dir type -- ok }

extern UMount { path -- ok }

extern Chown { path owner -- ok }

extern Chmod { path mode -- ok }

extern Sync { -- ok }

extern IOFlush { -- }

extern Seek { fd offset whence -- ok }

extern GetCWD { buf -- ok }

extern Halt { haltmode -- ok }

extern MemInfo { -- memtotal memused heaptotal heapused }

const SEG_WRITABLE 1

extern AllocSegment { flags bytes -- sd }

extern MapSegment { sd va must -- ok ava }

extern CloseSegment { sd -- ok }

extern UnmapSegment { sd -- ok }

extern AISIXGetMode { -- mode }

extern Time { -- sec ms }

extern FChown { fd owner -- ok }

extern FChmod { fd mode -- ok }

extern ProcessInfo { stat pid -- ok }

extern NextProcessInfo { stat oldindex -- newindex }

extern GetDeviceName { buf fd -- ok }

extern Kill { pid -- ok }

extern IOCtl { op1 op2 op3 op4 fd -- ok }

extern Rename { srcname destname -- ok }

const HALT_SHUTDOWN 1
const HALT_REBOOT 2

extern RealPath { path -- canon }

const TTY_MODE_RAW 1
const TTY_MODE_NOECHO 2

const TTY_IOCTL_INFO 1
const TTY_IOCTL_SET 2

struct TTYInfo
	4 Width
	4 Height
	4 Mode
	48 Reserved
endstruct

struct Stat
	4 Mode
	4 UID
	4 GID
	4 Size
	4 Type
	4 ATime
	4 MTime
	4 CTime
	32 Reserved
endstruct

struct UNameS
	256 Sysname
	256 Nodename
	256 Release
	256 Version
	256 Machine
	256 Processor
endstruct

struct ProcessStat
	4 Threads
	4 UID
	4 EUID

	4 Zombie

	4 PID

	4 MTStatus
	4 MTEvQ

	32 TTYName

	256 CWDPathString
	64 Name

	4 Parent

	32 Reserved
endstruct

const FS_READONLY 1
const FS_NOUID 2

const SEEK_SET 1
const SEEK_CUR 2
const SEEK_END 3

const STDIN 0
const STDOUT 1
const STDERR 2

const O_READ 1
const O_WRITE 2
const O_RW (O_READ O_WRITE |)
const O_TRUNC 4
const O_CLOEXEC 8
const O_CREATE 16
const O_APPEND 32

const NP_INHERIT 0
const NP_SPECIFY 1

const VNODE_FILE 1
const VNODE_DIR 2
const VNODE_CHAR 3
const VNODE_BLOCK 4

const WORLD_X 1
const WORLD_W 2
const WORLD_R 4

const GROUP_X 8
const GROUP_W 16
const GROUP_R 32

const OWNER_X 64
const OWNER_W 128
const OWNER_R 256

const SUID 512

const XMASK 73

const TTYI_ALL 0
const TTYI_IGN 1
const TTYI_CHILD_ALL 0x100
const TTYI_CHILD_IGN 0x200

struct UDVec
	4 Ptr
	4 Size
endstruct

struct Dirent
	256 Name
	32 Reserved
endstruct

const	EPERM	1
const	ENOENT	2
const	ESRCH	3
const	EINTR	4
const	EIO		5
const	ENXIO	6
const	E2BIG	7
const	ENOEXEC	8
const	EBADF	9
const	ECHILD	10
const	EAGAIN	11
const	ENOMEM	12
const	EACCES	13
const	ENOTBLK	15
const	EBUSY	16
const	EEXIST	17
const	EXDEV	18
const	ENODEV	19
const	ENOTDIR	20
const	EISDIR	21
const	EINVAL	22
const	ENFILE	23
const	EMFILE	24
const	ENOTTY	25
const	ETXTBSY	26
const	EFBIG	27
const	ENOSPC	28
const	ESPIPE	29
const	EROFS	30
const	EMLINK	31
const	EPIPE	32
const	EBADSYS	33
const	EFAULT  34
const	EMAPPED 35
const	ENOVMEM 36
const	ENMAPPED 37
const	EBADS   38
const   EMSEG   39

const	-EPERM	-1
const	-ENOENT	-2
const	-ESRCH	-3
const	-EINTR	-4
const	-EIO	-5
const	-ENXIO	-6
const	-E2BIG	-7
const	-ENOEXEC	-8
const	-EBADF	-9
const	-ECHILD	-10
const	-EAGAIN	-11
const	-ENOMEM	-12
const	-EACCES	-13
const	-ENOTBLK	-15
const	-EBUSY	-16
const	-EEXIST	-17
const	-EXDEV	-18
const	-ENODEV	-19
const	-ENOTDIR	-20
const	-EISDIR	-21
const	-EINVAL	-22
const	-ENFILE	-23
const	-EMFILE	-24
const	-ENOTTY	-25
const	-ETXTBSY	-26
const	-EFBIG	-27
const	-ENOSPC	-28
const	-ESPIPE	-29
const	-EROFS	-30
const	-EMLINK	-31
const	-EPIPE	-32
const	-EBADSYS	-33
const	-EFAULT -34
const	-EMAPPED -35
const   -ENOVMEM -36
const	-ENMAPPED -37
const	-EBADS -38
const	-EMSEG -39

externptr ErrorNames