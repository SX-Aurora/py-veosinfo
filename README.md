# py-veosinfo

## Introduction

Python bindings to libveosinfo that provides various details
on the SX-Aurora Vector Engines located in the current host:
* lists VEs in the system and their state,
* information in the VE architecture,
* information on caches, frequencies of each VE core,
* load and memory statistics of VEs,
* information on processes running on the VEs,
* fan, temperature, voltage of VEs,
* reading and setting the VE core affinity of processes,
* various statistical infos,
* a mechanism to read VE register values of own processes.

Not all calls of libveosinfo are implemented in these Python bindings.


## Build / Install

When installing from PYPI the module requires the package
*veosinfo-devel* to be installed.
```
pip install py-veosinfo
```

The module can be built from the cloned github repository, in that case
you must install *cython*.
```
git clone https://github.com/sx-aurora/py-veosinfo.git
cd py-veosinfo
make install
# or
make rpm
```

Building inside a virtualenv is easy, but it is recommended to build RPMs
from the source RPM outside the virtualenv, in order to get the paths right.


## Usage

In your python program import the `veosinfo` python module, for example by doing:
```
from veosinfo import *
```

Call the veosinfo functions.

The semantics and results were pythonified somewhat, we're not just
calling certain C library functions, but transform return structure
data into dicts, etc.


## Functions (from libveosinfo)

The usage example outputs have been slightly edited to fit better
on screen.

### `acct(int nodeid, char *filename)`

Enable and disable process accounting.

Parameters:
* `nodeid`: specify VE node,
* `filename`: file for recording accounting data.

Returns 0 on success, -1 on failure.


### `arch_info(int nodeid)`

Return a dict with VE architecture details.

Parameter:
* `nodeid`: specify VE node.

Returns 0 on success, -1 on error.

Example:
```
>>> arch_info(0)
{'machine': 've', 'hw_platform': 've', 'processor': 've'}
```


### `check_pid(int nodeid, int pid)`

Check whether a given *pid* exists as process on a given VE.

Parameters:
* `nodeid`: specify VE node,
* `pid`: process ID to be checked.

Returns 0 or 1 on success and -1 on failure:
* the value 0 indicates that *pid* is a valid process on the specified *nodeid*.
* the value 1 indicates thet *pid* does not rexist on the specified *nodeid*.


### `core_info(int nodeid)`

Returns the number of cores of a given VE specified by *nodeid*.

Example:
```
>>> core_info(0)
8
```

### `cpu_info(int nodeid)`

Returns a dict with CPU information for the specified *nodeid*. The
dict contains the attributes like modelname, vendor, family, stepping,
mhz, cache\_size, cores, model, cache\_name.

Example:
```
>>> cpu_info(0)
{'modelname': 'VE_1_136', 'vendor': '0x1bcf', 'family': '1', 'bogomips': '1400', 'nnodes': 1,
 'stepping': '0', 'core_per_socket': 8, 'op_mode': '64 bit', 'socket': 1, 'thread_per_core': 1,
 'mhz': '1400', 'cache_size': [32, 32, 256, 16384], 'cores': 8, 'model': '136',
 'cache_name': ['cache_l1i', 'cache_l1d', 'cache_l2', 'cache_llc']}
```


### `cpufreq_info(int nodeid)`

Returns the CPU frequency of the specified *nodeid*.

Example:
```
>>> cpufreq_info(0)
1400L
```


### `get_regvals(int nodeid, pid_t pid, list regid)`

Returns an array of register values for the VE process *pid* running
on VE *nodeid*. The values correspond to the array of register offsets
*regid*. Symbolic register offsets are available, eg. USRCC, PMC00,
S08, etc... At most 64 registers can be retrieved in one call.

Example:
```
>>> get_regvals(0, 246283, [USRCC, PMC00, PMC01])
[37939912918L, 38751941050L, 15117305941L]
```


### `loadavg_info(int nodeid)`

Returns a dict with the usual Linux load averages over 1, 5 and 15
minutes of the VE specified by *nodeid*.

Example:
```
>>> loadavg_info(0)
{'av_5': 0.0, 'av_15': 0.0, 'total_proc': 0, 'av_1': 0.0, 'runnable': 0}
```

### `mem_info(int nodeid)`

Retrieve memory information of the specified VE *nodeid*.

Example:
```
>>> mem_info(0)
{'kb_committed_as': 0L, 'kb_hugepage_used': 131072L, 'kb_low_total': 0L, 'kb_swap_cached': 0L,
 'kb_dirty': 0L, 'kb_main_total': 50331648L, 'kb_main_free': 50200576L, 'kb_swap_total': 0L,
 'kb_main_used': 131072L, 'kb_high_total': 0L, 'hugepage_free': 0L, 'kb_low_free': 0L,
 'kb_high_free': 0L, 'kb_active': 0L, 'kb_main_buffers': 0L, 'kb_swap_free': 0L,
 'kb_main_cached': 0L, 'kb_main_shared': 0L, 'kb_inactive': 0L, 'hugepage_total': 0L}
```

### `numa_info(int nodeid)`

Return NUMA stats dict for the specified VE *nodeid*.

Example:
```
>>> numa_info(0)
{'mem_free': [25635586048L, 25769803776L], 'mem_size': [25769803776L, 25769803776L], 've_core': ['f', 'f0'], 'tot_numa_nodes': 2}
```


### `node_info()`

Return information on online and offline VE nodes in the system.

Example:
```
>>> node_info()
{'status': [0], 'cores': [8], 'nodeid': [0], 'total_node_count': 1}
```

### `pidstat_info(int nodeid, pid_t pid)`

Returns a dict with statistics of the VE process specified by *pid* on
the VE node *nodeid*.

Example:
```
>>> pidstat_info(0, 334575)
{'min_flt': 0L, 'cutime': 0L, 'rss': 7680000, 'endcode': 105553117303192L, 'ksteip': 139716362733200L,
 'wchan': 0L, 'cguest_time': 0, 'start_time': 2709686L, 'cstime': 0L, 'maj_delta': 0L, 'cmaj_flt': 0L,
 'nswap': 0L, 'cmin_flt': 0L, 'stime': 0L, 'startstack': 106652627894256L, 'kstesp': 106652627890808L,
 'startcode': 105553116266496L, 'guest_time': 0, 'utime': 36888115L, 'cnswap': 0L, 'min_delta': 0L,
 'rsslim': 18446744073709551615L, 'maj_flt': 0L, 'rt_priority': 0, 'cmd': 'sgemm', 'priority': 20,
 'blkio': 0L, 'state': 82, 'flags': 0L, 'whole': False, 'policy': 0, 'ppid': 1, 'vsize': 7864320000L,
 'processor': 0, 'itrealvalue': 0L, 'nice': 0}
```


### `read_fan(int nodeid)`

Returns information about the fan speeds of a certain VE node.

Example:
```
>>> read_fan(0)
{'count': 0, 
 'fan_min': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
 'fan_speed': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
 'fan_max': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
 'device_name': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']}
```


### `read_temp(int nodeid)`

Returns information about the temperature sensors of the specified VE
node *nodeid*.

Example:
```
>>> read_temp(0)
{'count': 19, 
 'temp_max': [125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 2.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 0.0], 
 've_temp': [36.125, 36.375, 36.0, 36.375, 36.5, 36.625, 36.125, 36.125, 29.0, 27.75, 33.5, 36.5, 25.75, 31.0, 32.0, 32.0, 31.0, 32.0, 31.0, 0.0], 
 'temp_min': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
 'device_name': ['ve_core0_temp', 've_core1_temp', 've_core2_temp', 've_core3_temp', 've_core4_temp',
                 've_core5_temp', 've_core6_temp', 've_core7_temp', 've_temp_bracket', 've_temp_adt7462',
                 've_temp_ve_diode_0', 've_temp_ve_diode_1', 've_temp_aux', 've_hbm0_temp',
                 've_hbm1_temp', 've_hbm2_temp', 've_hbm3_temp', 've_hbm4_temp', 've_hbm5_temp', '']}
```


### `read_voltage(int nodeid)`

Returns voltage information of several sensors on the specified VE.

Example:
```
>>> read_voltage(0)
{'count': 14, 
 'cpu_volt': [0.8875, 0.9048, 1.245699, 1.243502, 1.243502, 1.245699, 2.473822, 1.770782, 11.875, 11.8125, 3.4572, 0.89, 0.89, 0.89125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
 'volt_max': [1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 4.0, 2.0, 16.0, 16.0, 4.0, 2.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
 'volt_min': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
 'device_name': ['ve_vdd', 've_avdd', 've_hbm_e_vddc', 've_hbm_e_vddq', 've_hbm_w_vddc',
                 've_hbm_w_vddq', 've_vpp', 've_vddh', 've_power_edge_12v', 've_eps12v',
                 've_power_edge_3.3v', 've_core_vdd0', 've_core_vdd1', 've_pll_089',
                 '', '', '', '', '', '']}
```

### `sched_getaffinity(int nodeid, pid_t pid)` and `sched_setaffinity(int nodeid, pid_t pid, uint64_t mask)`

A VE thread's CPU affinity mask determines the set of cores on its VE
node on which it is eligible to run. These functions are equivalent to
the normal Linux
[*sched_getaffinity(2)*](https://linux.die.net/man/2/sched_getaffinity)
and
[*sched_setaffinity(2)*](https://linux.die.net/man/2/sched_setaffinity)
calls but refers to a particular *pid* running on a particular
*nodeid*. Setting the VE core affinity of a thread requires as third
argument a bitmask that specifies the cores. For 8 cores only the
lowest 8 bits are relevant.

The functions return 0 on success and -1 on failure.

Example:
```
>>> from veosinfo import *
>>> sched_getaffinity(0, 23360)
255L
>>> sched_setaffinity(0, 23360, 0x4)
4L
>>> sched_getaffinity(0, 23360)
4L
```

### `stat_info(int nodeid)`

Returns CPU statistics information of each code of the specified VE.

Example:
```
>>> stat_info(0)
{'btime': 1519312224282053L, 'processes': 270, 'softirq': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L],
 'iowait': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'hardirq': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L],
 'running': 0, 'guest': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'sys': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L],
 'idle': [18035571395L, 18381719995L, 18381772644L, 18381423124L, 18381746994L, 18381771739L, 18169013077L, 18381422057L],
 'user': [449605113L, 103456497L, 103403842L, 103753357L, 103429482L, 103404732L, 316163387L, 103754403L],
 'guest_nice': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'intr': 0, 'blocked': 0,
 'steal': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'ctxt': 262, 'nice': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L]}
```

### `uptime_info(int nodeid)`

Uptime in seconds of the specified VE *nodeid*. This is the time since
the latest boot of VEOS for that VE.

Example:
```
>>> uptime_info(0)
386214.28571428574
```

### `vmstat_info(int nodeid)`

Returns virtual memory statistics information of the specified VE node.

Example:
```
>>> vmstat_info(0)
{'pswpout': 0L, 'pgscan_direct': 0L, 'pswpin': 0L, 'pgmajfault': 0L,
 'pgfault': 0L, 'pgscan_kswapd': 0L, 'pgsteal': 0L, 'pgfree': 0L}
```

### `ve_sysfs_path(int nodeid)`

Return VE sysfs path corresponding to a certain VE *nodeid*.

Example:
```
>>> ve_sysfs_path(0)
'/sys/devices/pci0000:64/0000:64:00.0/0000:65:00.0/ve/ve1'
```


## Added functionality beyond libveosinfo


### VE Register Offsets

The VE registers readable with `get_regvals()` must be addressed with
their offsets in the register "file". These offsets are available in
the Python *veosinfo* module as constants. Their names are the
symbolic names used inside VEOS:

* `USRCC`: User Clock Counter.
* `PMC00 - PMC15`: Performance Monitoring Counters.
* `PSW`: Process Status Word.
* `EXS`: Execution Status and Control Register.
* `IC`: Instruction Counter or instruction pointer.
* `ICE`: Exception IC Register, approximate instruction counter at an exception.
* `VIXR`: Vector Index Register, used for indirect access to vector registers.
* `VL`: Vector Length Register.
* `SAR`: Store Address Register, holds an address for generating address match interrupts for store operations to it.
* `PMMR`: Performance Monitoring Mode Register.
* `PMCR00 - PMCR04`: Performance Monitoring Configuration Registers.
* `SR00 - SR63`: Scalar Registers.


### `ve_pids(int nodeid)`

List of task IDs running on a certain VE node. This is created by
reading the file *task_id_all* from the directory returned by
*ve_sysfs_path()*.

Example:
```
>>> ve_pids(0)
[298038, 298002]
```


### `ve_pid_perf(int nodeid, int pid)`

Create a dict with performance counter values for a certain *pid* on a
VE *nodeid*. The counters correspond to the settings in the *PMMR*
register, which decide upon the counters actually measured in the
various *PMC* registers. *ve_pid_perf()* also adds the key "T" which
contains the epoch (time in seconds since January 1, 12:00am 1970) at
the measurement.

Consecutive calls of *ve_pid_perf()* are used to calculate performance
metrics of running VE programs in the tools *veperf*.

Example:
```
>>> ve_pid_perf(0, 298002)
{'VLEC': 474579296208L, 'VLCME': 19891534L, 'VE2': 8062493240158L, 'VE': 8062492910686L,
 'PCCC': 37961384L, 'VECC': 79381274156L, 'VLDEC': 212519229L, 'USRCC': 79385051298L,
 'FPEC': 15167113230887L, 'FMAEC': 7583557736960L, 'EX': 81071288934L, 'TTCC': 0L,
 'VX': 31640583719L, 'L1MCC': 270252L, 'VAREC': 79167929328L, 'VLDCC': 30875413736L,
 'PTCC': 0L, 'T': 1544384688.252721}
```

For an explanation of the meaning of the performance counters, please
consult the "SX-Aurora TSUBASA Architectur Guide".
