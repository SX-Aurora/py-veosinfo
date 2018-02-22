##########################################################################
# Python bindings to libveosinfo
#
# Provides various bits of information about the SX-Aurora
# vector engines (VEs) in the system.
#
# (C)opyright 2018 Erich Focht
#
# This program module is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either version
# 2.1 of the License, or (at your option) any later version.
#
# The VEOS information library Python bindings module is distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the VEOS information library python bindings module; if not,
# see <http://www.gnu.org/licenses/>.
##########################################################################

from posix.time cimport timeval
from posix.resource cimport rlimit

ctypedef int pid_t
        
cdef extern from "<sched.h>":
    enum: __CPU_SETSIZE
    enum: __NCPUBITS
    ctypedef unsigned long int __cpu_mask
    ctypedef struct cpu_set_t:
        __cpu_mask __bits[__CPU_SETSIZE / __NCPUBITS]

cdef extern from "<veosinfo/veosinfo.h>":
    enum: VE_MAX_NODE
    enum: VE_PATH_MAX
    enum: VE_FILE_MAX
    enum: VE_BUF_LEN
    enum: VE_MAX_CORE_PER_NODE
    enum: VMFLAGS_LENGTH
    enum: VE_MAX_CACHE
    enum: VE_DATA_LEN
    enum: MAX_DEVICE_LEN
    enum: MAX_POWER_DEV
    enum: VE_PAGE_SIZE
    enum: VKB
    enum: EXECVE_MAX_ARGS
    enum: MICROSEC_TO_SEC
    DEF VE_EXEC_PATH = "/opt/nec/ve/bin/ve_exec"
    DEF VE_NODE_SPECIFIER = "-N"

    cdef struct ve_nodeinfo:
        int nodeid[VE_MAX_NODE]
        int status[VE_MAX_NODE]
        int cores[VE_MAX_NODE]
        int total_node_count

    cdef struct ve_archinfo:
        char machine[VE_FILE_MAX]
        char processor[257]
        char hw_platform[257]

    struct ve_meminfo:
        unsigned long kb_main_total
        unsigned long kb_main_used
        unsigned long kb_main_free
        unsigned long kb_main_shared
        unsigned long kb_main_buffers
        unsigned long kb_main_cached
        unsigned long kb_swap_cached
        unsigned long kb_low_total
        unsigned long kb_low_free
        unsigned long kb_high_total
        unsigned long kb_high_free
        unsigned long kb_swap_total
        unsigned long kb_swap_free
        unsigned long kb_active
        unsigned long kb_inactive
        unsigned long kb_dirty
        unsigned long kb_committed_as
        unsigned long hugepage_total
        unsigned long hugepage_free
        unsigned long kb_hugepage_used

    struct ve_loadavg:
        double av_1
        double av_5
        double av_15
        int runnable
        int total_proc

    struct ve_cpuinfo:
        int cores
        int thread_per_core
        int core_per_socket
        int socket
        char vendor[VE_DATA_LEN]
        char family[VE_DATA_LEN]
        char model[VE_DATA_LEN]
        char modelname[VE_DATA_LEN]
        char mhz[VE_DATA_LEN]
        char stepping[VE_DATA_LEN]
        char bogomips[VE_DATA_LEN]
        int  nnodes
        char op_mode[VE_DATA_LEN]
        char cache_name[VE_MAX_CACHE][VE_BUF_LEN]
        int cache_size[VE_MAX_CACHE]

    struct ve_statinfo:
        unsigned long long user[VE_MAX_CORE_PER_NODE]
        unsigned long long nice[VE_MAX_CORE_PER_NODE]
        unsigned long long idle[VE_MAX_CORE_PER_NODE]
        unsigned long long iowait[VE_MAX_CORE_PER_NODE]
        unsigned long long sys[VE_MAX_CORE_PER_NODE]
        unsigned long long hardirq[VE_MAX_CORE_PER_NODE]
        unsigned long long softirq[VE_MAX_CORE_PER_NODE]
        unsigned long steal[VE_MAX_CORE_PER_NODE]
        unsigned long guest[VE_MAX_CORE_PER_NODE]
        unsigned long guest_nice[VE_MAX_CORE_PER_NODE]
        unsigned int intr
        unsigned int ctxt
        unsigned int running
        unsigned int blocked
        unsigned long btime
        unsigned int processes

    struct ve_vmstat:
        unsigned long pgfree
        unsigned long pgscan_direct
        unsigned long pgsteal
        unsigned long pswpin
        unsigned long pswpout
        unsigned long pgfault
        unsigned long pgmajfault
        unsigned long pgscan_kswapd

    struct ve_mapheader:
        unsigned int length
        int shmid

    struct ve_mapinfo:
        unsigned long long start
        unsigned long long end
        char perms[32]
        unsigned long long offset
        unsigned long long inode
        unsigned int dev_major
        unsigned int dev_minor
        char map_desc[128]
        unsigned long long size
        unsigned long long rss
        unsigned long long pss
        unsigned long long shared_dirty
        unsigned long long private_dirty
        unsigned long long shared_clean
        unsigned long long private_clean
        unsigned long long referenced
        unsigned long long anonymous
        unsigned long long anon_hugepage
        unsigned long long swap
        unsigned long long mmu_pagesize
        unsigned long long locked
        unsigned long long pagesize
        char vmflags[VMFLAGS_LENGTH]

    struct ve_pidstat:
        char state
        int ppid
        int processor
        long priority
        long nice
        unsigned int policy
        unsigned int rt_priority
        unsigned long long utime
        long cguest_time
        long guest_time
        unsigned long long cutime
        unsigned long long stime
        unsigned long long cstime
        unsigned long long wchan
        unsigned long flags
        unsigned long vsize
        unsigned long rsslim
        unsigned long startcode
        unsigned long endcode
        unsigned long startstack
        unsigned long kstesp
        unsigned long ksteip
        long rss
        unsigned long min_flt
        unsigned long maj_flt
        unsigned long cmin_flt
        unsigned long cmaj_flt
        unsigned long maj_delta
        unsigned long min_delta
        unsigned long long blkio
        unsigned long long nswap
        unsigned long long cnswap
        unsigned long long itrealvalue
        char cmd[255]
        unsigned long start_time
        bint whole

    struct ve_pidstatus:
        unsigned long vm_swap
        unsigned long nvcsw
        unsigned long nivcsw
        char cmd[255]
        unsigned long long sigpnd
        unsigned long long blocked
        unsigned long long sigignore
        unsigned long long sigcatch

    struct ve_pidstatm:
        long size
        long resident
        long share
        long trs
        long drs
        long dt

    struct ve_get_rusage_info:
        timeval utime
        timeval stime
        timeval elapsed
        long ru_maxrss
        long ru_ixrss
        long ru_idrss
        long ru_isrss
        long ru_minflt
        long ru_majflt
        long ru_nswap
        long ru_nvcsw
        long ru_nivcsw
        long page_size

    struct ve_pwr_fan:
        char device_name[MAX_POWER_DEV][MAX_DEVICE_LEN]
        int count
        double fan_min[MAX_POWER_DEV]
        double fan_max[MAX_POWER_DEV]
        double fan_speed[MAX_POWER_DEV]

    struct ve_pwr_temp:
        char device_name[MAX_POWER_DEV][MAX_DEVICE_LEN]
        int count
        double temp_min[MAX_POWER_DEV]
        double temp_max[MAX_POWER_DEV]
        double ve_temp[MAX_POWER_DEV]

    struct ve_pwr_voltage:
        char device_name[MAX_POWER_DEV][MAX_DEVICE_LEN]
        int count
        double volt_min[MAX_POWER_DEV]
        double volt_max[MAX_POWER_DEV]
        double cpu_volt[MAX_POWER_DEV]


    int ve_get_nos(unsigned int *, int *)
    int ve_acct(int nodeid, char *filename)
    int ve_arch_info(int nodeid, ve_archinfo *archinfo)
    int ve_check_pid(int nodeid, int pid)
    int ve_core_info(int nodeid, int *cores)
    int ve_cpu_info(int, ve_cpuinfo *)
    int ve_cpufreq_info(int, unsigned long *)
    int ve_create_process(int nodeid, int pid, int flag)
    int ve_loadavg_info(int, ve_loadavg *)
    int ve_mem_info(int, ve_meminfo *)
    int ve_node_info(ve_nodeinfo *)
    int ve_pidstat_info(int, pid_t, ve_pidstat *)
    int ve_read_fan(int, ve_pwr_fan *)
    int ve_read_temp(int, ve_pwr_temp *)
    int ve_read_voltage(int, ve_pwr_voltage *)
    int ve_stat_info(int, ve_statinfo *)
    int ve_uptime_info(int, double *)
    int ve_vmstat_info(int, ve_vmstat *)

    int ve_get_rusage(int, pid_t, ve_get_rusage_info *)
    int ve_map_info(int, pid_t, ve_mapheader *)
    int ve_pidstatus_info(int, pid_t, ve_pidstatus *)
    int ve_pidstatm_info(int, pid_t, ve_pidstatm *)
    int ve_prlimit(int, pid_t, int, rlimit *, rlimit *)
    int ve_sched_getaffinity(int nodeid, pid_t pid, size_t cpusetsize, cpu_set_t *mask)
    int ve_sched_setaffinity(int nodeid, pid_t pid, size_t cpusetsize, cpu_set_t *mask)

    
from libc.stdint cimport intptr_t

def acct(int nodeid, char *filename):
    if ve_acct(nodeid, filename):
        raise RuntimeError("ve_acct failed")

def arch_info(int nodeid):
    cdef ve_archinfo ai
    if ve_arch_info(nodeid, &ai):
        raise RuntimeError("ve_arch_info failed")
    return ai

cpdef bint check_pid(int nodeid, int pid) except -1:
    cdef int rc
    cdef bint res = False
    rc = ve_check_pid(nodeid, pid)
    if rc < 0:
        raise RuntimeError("ve_check_pid (%d) failed: %d" % (pid, rc))
    elif rc == 0:
        res = True
    return res

def core_info(int nodeid):
    cdef int cores
    if ve_core_info(nodeid, &cores):
        raise RuntimeError("ve_core_info failed")
    return cores

def cpu_info(int nodeid):
    cdef ve_cpuinfo ci
    if ve_cpu_info(nodeid, &ci):
        raise RuntimeError("ve_cpu_info failed")
    return ci

def cpufreq_info(int nodeid):
    cdef unsigned long freq
    if ve_cpufreq_info(nodeid, &freq):
        raise RuntimeError("ve_cpufreq_info failed")
    return freq

def create_process(int nodeid, int pid, int flag):
    if ve_create_process(nodeid, pid, flag):
        raise RuntimeError("ve_create_process failed")
    return True

def loadavg_info(int nodeid):
    cdef ve_loadavg la
    if ve_loadavg_info(nodeid, &la):
        raise RuntimeError("ve_loadavg_info failed")
    return la

def mem_info(int nodeid):
    cdef ve_meminfo mi
    if ve_mem_info(nodeid, &mi):
        raise RuntimeError("ve_mem_info failed")
    return mi

def node_info():
    cdef ve_nodeinfo vni
    if ve_node_info(&vni):
        raise RuntimeError("ve_node_info failed")
    cdef object d = vni
    for key in ("nodeid", "status", "cores"):
        d[key] = d[key][:d["total_node_count"]]
    return d

def pidstat_info(int nodeid, pid_t pid):
    cdef ve_pidstat p
    if ve_pidstat_info(nodeid, pid, &p):
        raise RuntimeError("ve_pidstat_info failed")
    return p

def read_fan(int nodeid):
    cdef ve_pwr_fan f
    if ve_read_fan(nodeid, &f):
        raise RuntimeError("ve_read_fan failed")
    return f

def read_temp(int nodeid):
    cdef ve_pwr_temp t
    if ve_read_temp(nodeid, &t):
        raise RuntimeError("ve_read_temp failed")
    return t

def read_voltage(int nodeid):
    cdef ve_pwr_voltage v
    if ve_read_voltage(nodeid, &v):
        raise RuntimeError("ve_read_voltage failed")
    return v

def stat_info(int nodeid):
    ni = node_info()
    if nodeid >= ni["total_node_count"]:
        raise ValueError("Wrong node ID: %d. Only %d node online." %
                         (nodeid, ni["total_node_count"]))
    cores = ni["cores"][nodeid]
    cdef ve_statinfo si
    if ve_stat_info(nodeid, &si):
        raise RuntimeError("ve_stat_info failed")
    cdef object d = si
    for key in ("user", "nice", "idle", "iowait", "sys", "hardirq",
                "softirq", "steal", "guest", "guest_nice"):
        d[key] = d[key][:cores]
    return d

def uptime_info(int nodeid):
    cdef double up
    if ve_uptime_info(nodeid, &up):
        raise RuntimeError("ve_uptime_info failed")
    return up

def vmstat_info(int nodeid):
    cdef ve_vmstat s
    if ve_vmstat_info(nodeid, &s):
        raise RuntimeError("ve_vmstat_info failed")
    return s

