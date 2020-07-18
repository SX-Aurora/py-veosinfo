##########################################################################
#
# This program module is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License, or (at your option) any later version.
#
# The VEOS information library Python bindings module is distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the VEOS information library python bindings module; if not,
# see <http://www.gnu.org/licenses/>.
#
# (C)opyright 2018-2020 Erich Focht
#
# The include file <veosinfo/veosinfo.h> required for building this
# package is licensed under the LGPLv2.1 and copyright by NEC Corporation.
# It is available in the RPM veosinfo-devel.
#
#-------------------------------------------------------------------------
#
# Python bindings for libveosinfo
#
# Provides various bits of information about the SX-Aurora
# vector engines (VEs) in the system.
#
##########################################################################

from posix.time cimport timeval
from posix.resource cimport rlimit
from libc.stdint cimport uint64_t
from libc.string cimport memset
import os
import os.path
import time

ctypedef int pid_t
        
cdef extern from "<sched.h>":
    enum: __CPU_SETSIZE
    enum: __NCPUBITS
    ctypedef unsigned long int __cpu_mask
    ctypedef struct cpu_set_t:
        unsigned long int __bits[__CPU_SETSIZE / __NCPUBITS]

cdef extern from "<sys/param.h>":
    enum: PATH_MAX

cdef extern from "<veosinfo/veosinfo.h>":
    enum: VE_EINVAL_COREID   # -514  Error number for invalid cores
    enum: VE_EINVAL_NUMAID   # -515  Error number for invalid NUMA node
    enum: VE_EINVAL_LIMITOPT # -516  Error number for invalid VE_LIMIT_OPT
    enum: VE_ERANGE_LIMITOPT # -517  Error number if limit is out of range
    enum: VEO_PROCESS_EXIST  #  515  Identifier for VEO API PID
    enum: VE_VALID_THREAD    #  516  Identifier for process/thread
    enum: VE_MAX_NODE        #  8    Maximum number of VE nodes
    enum: VE_PATH_MAX        # 4096
    enum: VE_FILE_NAME       # 255   Maximum length of file name
    enum: FILENAME           # 15    Length of file used to get
                             #       pmap/ipcs/ipcrm command information
    enum: VE_BUF_LEN         # 255
    enum: VE_MAX_CORE_PER_NODE  # 16
    enum: VMFLAGS_LENGTH        # 81
    enum: VE_MAX_CACHE          # 4  max number of VE caches
    enum: VE_DATA_LEN           # 20
    enum: VE_MAX_REGVALS        # 64
    enum: MAX_DEVICE_LEN        # 255
    enum: MAX_POWER_DEV         # 20
    enum: VE_PAGE_SIZE          # 2097152
    enum: VKB                   # 1024
    enum: EXECVE_MAX_ARGS       # 256
    enum: MICROSEC_TO_SEC       # 1000000
    enum: VE_NUMA_NUM           # 2  maximum number of NUMA nodes in a VE
    enum: MAX_CORE_IN_HEX 4     # 4  maximum core value in HEX
    enum: MAX_SWAP_PROCESS      # 256 maximum number of swapped processes
    DEF VE_EXEC_PATH = "/opt/nec/ve/bin/ve_exec"
    DEF VE_NODE_SPECIFIER = "-N"

    cdef struct ve_nodeinfo:
        int nodeid[VE_MAX_NODE]
        int status[VE_MAX_NODE]
        int cores[VE_MAX_NODE]
        int total_node_count

    cdef struct ve_archinfo:
        char machine[VE_FILE_NAME]
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
        pid_t tgid;

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

    enum ipc_mode:
        SHMKEY_RM      # Delete shm segment using key
        SHMID_RM       # Delete shm segment using shmid
        SHM_RM_ALL     # Delete all shm segment
        SHMID_INFO     # Information of given shm segment
        SHM_LS         # List All segment
        SHM_SUMMARY    # Summary of shared Memory
        SHMID_QUERY    # Query whether shmid is valid or not
        SHMKEY_QUERY   # Query whether shmkey is valid or not

    struct ve_numa_stat:
        int tot_numa_nodes
        char ve_core[VE_NUMA_NUM][MAX_CORE_IN_HEX]  # list of cores in each NUMA node
        unsigned long long mem_size[VE_NUMA_NUM]    # memory size of each NUMA node
        unsigned long long mem_free[VE_NUMA_NUM]    # Free memory in each NUMA node


    int ve_get_nos(unsigned int *, int *)
    int ve_acct(int nodeid, char *filename)
    int ve_arch_info(int nodeid, ve_archinfo *archinfo)
    int ve_check_pid(int nodeid, int pid)
    int ve_core_info(int nodeid, int *cores)
    int ve_cpu_info(int, ve_cpuinfo *)
    int ve_cpufreq_info(int, unsigned long *)
    int ve_create_process(int nodeid, int pid, int flag, int numa_num,
                          int membind_flag, cpu_set_t *set)
    int ve_get_regvals(int, pid_t, int, int *, uint64_t *)
    int ve_loadavg_info(int, ve_loadavg *)
    int ve_mem_info(int, ve_meminfo *)
    int ve_node_info(ve_nodeinfo *)
    int ve_pidstat_info(int, pid_t, ve_pidstat *)
    int ve_read_fan(int, ve_pwr_fan *)
    int ve_read_temp(int, ve_pwr_temp *)
    int ve_read_voltage(int, ve_pwr_voltage *)
    int ve_sched_getaffinity(int nodeid, pid_t pid, size_t cpusetsize, cpu_set_t *mask)
    int ve_sched_setaffinity(int nodeid, pid_t pid, size_t cpusetsize, cpu_set_t *mask)
    int ve_stat_info(int, ve_statinfo *)
    int ve_uptime_info(int, double *)
    int ve_vmstat_info(int, ve_vmstat *)
    int ve_check_node_status(int)
    int ve_numa_info(int, ve_numa_stat *)

    # functions below have no python equivalent, yet
    int ve_get_rusage(int, pid_t, ve_get_rusage_info *)
    int ve_map_info(int, pid_t, ve_mapheader *)
    int ve_pidstatus_info(int, pid_t, ve_pidstatus *)
    int ve_pidstatm_info(int, pid_t, ve_pidstatm *)
    int ve_prlimit(int, pid_t, int, rlimit *, rlimit *)

    # not yet implemented
    # int ve_delete_dummy_task(int, pid_t)
    # int ve_shm_list_or_remove(int , int , unsigned int *, char *)
    # int ve_chk_exec_format(char *)
    # int ve_swap_statusinfo(int, ve_swap_pids *, ve_swap_status_info *)
    # int ve_swap_info(int, ve_swap_pids *, ve_swap_info *)
    # int ve_swap_nodeinfo(int, ve_swap_node_info *)
    # int ve_swap_out(int, ve_swap_pids *)
    # int ve_swap_in(int, ve_swap_pids *)

    
# declared in internal include file, but useful little helper function
cdef extern int ve_sysfs_path_info(int nodeid, char *ve_sysfs_path)


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

# @brief Check status (online/offline) of a given VE node.
# @param nodeid VE node number to check status.
# @return 0 on success (online) and -1 on failure (offline)
def check_node_status(int nodeid):
    return ve_check_node_status(nodeid)

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

def create_process(int nodeid, int pid, int flag, int numa_num,
                   int membind_flag):
    #cdef cpu_set_t s
    cdef long s[__CPU_SETSIZE / __NCPUBITS]
    if ve_create_process(nodeid, pid, flag, numa_num, membind_flag, <cpu_set_t *>&s[0]):
        raise RuntimeError("ve_create_process failed")
    return s

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

def sched_getaffinity(int nodeid, pid_t pid):
    cdef uint64_t mask;
    if ve_sched_getaffinity(nodeid, pid, sizeof(mask), <cpu_set_t *>&mask):
        raise RuntimeError("ve_sched_getaffinity failed!")
    return mask

def sched_setaffinity(int nodeid, pid_t pid, uint64_t mask):
    if ve_sched_setaffinity(nodeid, pid, sizeof(mask), <cpu_set_t *>&mask):
        raise RuntimeError("ve_sched_setaffinity failed!")
    return mask

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

#
# VE register IDs usable to retrieve registers with ve_get_regvals()
#
cpdef enum VERegIds:
    USRCC = 0,
    PMC00, PMC01, PMC02, PMC03, PMC04, PMC05, PMC06,
    PMC07, PMC08, PMC09, PMC10, PMC11, PMC12, PMC13,
    PMC14, PMC15,
    PSW, EXS, IC, ICE, VIXR, VL, SAR,
    PMMR, PMCR00, PMCR01, PMCR02, PMCR03, PMCR04,
    SR00, SR01, SR02, SR03, SR04, SR05, SR06, SR07,
    SR08, SR09, SR10, SR11, SR12, SR13, SR14, SR15,
    SR16, SR17, SR18, SR19, SR20, SR21, SR22, SR23,
    SR24, SR25, SR26, SR27, SR28, SR29, SR30, SR31,
    SR32, SR33, SR34, SR35, SR36, SR37, SR38, SR39,
    SR40, SR41, SR42, SR43, SR44, SR45, SR46, SR47,
    SR48, SR49, SR50, SR51, SR52, SR53, SR54, SR55,
    SR56, SR57, SR58, SR59, SR60, SR61, SR62, SR63

def get_regvals(int nodeid, pid_t pid, list regid):
    cdef uint64_t ve_regval[VE_MAX_REGVALS]
    cdef int ve_regid[VE_MAX_REGVALS], i = 0
    regid = regid[:VE_MAX_REGVALS]
    for rid in regid:
        ve_regid[i] = regid[i]
        i += 1
    if ve_get_regvals(nodeid, pid, len(regid), ve_regid, &ve_regval[0]):
        raise RuntimeError("ve_get_regvals failed")
    cdef list regval = list()
    for i in xrange(len(regid)):
        regval.append(ve_regval[i])
    return regval

#
# Return VE sysfs path corresponding to a certain nodeid
#
def ve_sysfs_path(int nodeid):
    cdef char sysfs_path[PATH_MAX]
    memset(sysfs_path, 0, PATH_MAX)
    if ve_sysfs_path_info(nodeid, &sysfs_path[0]):
        raise RuntimeError("ve_sysfs_path_info failed")
    return sysfs_path

#
# List of task IDs running on a certain VE node.
#
def ve_pids(int nodeid):
    sysfs_path = ve_sysfs_path(nodeid)
    pids = list()
    with open(os.path.join(sysfs_path, "task_id_all"), "r") as f:
        for line in f:
            line = line.rstrip(os.linesep)
            for l in line.split(" "):
                try:
                    pids.append(int(l))
                except:
                    pass
    return pids


VEREGS = [USRCC, PMMR, PMC00, PMC01, PMC02, PMC03, PMC04, PMC05, PMC06,
          PMC07, PMC08, PMC09, PMC10, PMC11, PMC12, PMC13, PMC14, PMC15]

PMC_NAME = [ { 0:    "EX"},                                                # 00
             { 0:    "VX"},                                                # 01
             { 0:  "FPEC"},                                                # 02
             { 0:    "VE",              2: "L1IMC"},                       # 03
             { 0:  "VECC",              2: "L1IAC"},                       # 04
             { 0: "L1MCC", 1:  "L2MCC", 2: "L1OMC",             8: "UXC"}, # 05
             { 0:   "VE2",              2: "L1OAC",             8: "UEC"}, # 06
             { 0: "VAREC", 1: "L1IMCC", 2:  "L2MC"},                       # 07
             { 0: "VLDEC", 1: "L1OMCC", 2:  "L2AC"},                       # 08
             { 0:  "PCCC", 1:   "LTRC", 2:  "BREC", 3: "SARCC"},           # 09
             { 0: "VLDCC", 1:   "STRC", 2:  "BPFC", 3: "IPHCC"},           # 10
             { 0:  "VLEC",              2:  "VLXC"},                       # 11
             { 0: "VLCME", 1: "VLCME2", 2: "VLCMX", 3: "VLCMX2"},          # 12
             { 0: "FMAEC",              2: "FMAXC"},                       # 13
             { 0: "PTCC"},                                                 # 14
             { 0: "TTCC"}                                                  # 15
]


def ve_pid_perf(int nodeid, int pid):
    """
    Create a dict with performance counter values for
    a certain pid on a VE node.
    """
    res = dict()
    regval = get_regvals(nodeid, pid, VEREGS)
    res["T"] = time.time()
    res["USRCC"] = regval[0]
    pmmr = regval[1]
    for i in xrange(16):
        mode = (pmmr >> (60 - (i * 4))) & 3
        if mode in PMC_NAME[i]:
            regname = PMC_NAME[i][mode]
        else:
            raise RuntimeError("Illegal mode in PMMR: PMC%d mode=%d" % i, mode)
        res[regname] = regval[2 + i]
    return res


# @brief Get the NUMA statistics for given VE node.
# @param nodeid[in] VE node number
# @return populated numa stat structure
# raises RuntimeError when failing
def numa_info(int nodeid):
    cdef ve_numa_stat ns
    if ve_numa_info(nodeid, &ns):
        raise RuntimeError("ve_numa_info failed")
    return ns
