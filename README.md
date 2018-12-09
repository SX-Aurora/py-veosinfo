# py-veosinfo

## Introduction

Python bindings to libveosinfo that provides various details
on the SX-Aurora Vector Engines located in the current host:
* lists VEs in the system and their state
* information in the VE architecture
* information on caches, frequencies of each VE core
* load and memory statistics of VEs
* information on processes running on the VEs
* fan, temperature, voltage of VEs
* various statistical infos
* a mechanism to read VE register values of own processes

Not all calls of libveosinfo are implemented in these Python bindings.

## Usage

In your python program import the `veosinfo` python module.

```
from veosinfo import *
```

Call the veosinfo functions.

The semantics was pythonified somewhat, we're not just calling
certain C library functions, but transform return structure data
into dicts, etc.


## Functions

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

