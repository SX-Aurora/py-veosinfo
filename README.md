# py-veosinfo

Python bindings to libveosinfo provided functionality as delivered to Aurora with the veosinfo RPM.


## Functions

acct(int nodeid, char *filename):

arch_info(int nodeid):

check_pid(int nodeid, int pid):

core_info(int nodeid):

cpu_info(int nodeid):

cpufreq_info(int nodeid):

create_process(int nodeid, int pid, int flag):

loadavg_info(int nodeid):

mem_info(int nodeid):

node_info():

pidstat_info(int nodeid, pid_t pid):

read_fan(int nodeid):

read_temp(int nodeid):

read_voltage(int nodeid):

stat_info(int nodeid):

uptime_info(int nodeid):

vmstat_info(int nodeid):



## Usage examples
```python
>>> from veosinfo import *

>>> node_info()
{'status': [0], 'cores': [8], 'nodeid': [0], 'total_node_count': 1}

>>> arch_info(0)
{'machine': 've', 'hw_platform': 've', 'processor': 've'}

>>> core_info(0)
8

>>> cpu_info(0)
{'modelname': 'VE_1_136', 'vendor': '0x1bcf', 'family': '1', 'bogomips': '1400', 'nnodes': 1, 'stepping': '0', 'core_per_socket': 8, 'op_mode': '64 bit', 'socket': 1, 'thread_per_core': 1, 'mhz': '1400', 'cache_size': [32, 32, 256, 16384], 'cores': 8, 'model': '136', 'cache_name': ['cache_l1i', 'cache_l1d', 'cache_l2', 'cache_llc']}

>>> cpufreq_info(0)
1400L

>>> loadavg_info(0)
{'av_5': 0.0, 'av_15': 0.0, 'total_proc': 0, 'av_1': 0.0, 'runnable': 0}

>>> mem_info(0)
{'kb_committed_as': 0L, 'kb_hugepage_used': 131072L, 'kb_low_total': 0L, 'kb_swap_cached': 0L, 'kb_dirty': 0L, 'kb_main_total': 50331648L, 'kb_main_free': 50200576L, 'kb_swap_total': 0L, 'kb_main_used': 131072L, 'kb_high_total': 0L, 'hugepage_free': 0L, 'kb_low_free': 0L, 'kb_high_free': 0L, 'kb_active': 0L, 'kb_main_buffers': 0L, 'kb_swap_free': 0L, 'kb_main_cached': 0L, 'kb_main_shared': 0L, 'kb_inactive': 0L, 'hugepage_total': 0L}

>>> read_fan(0)
{'count': 0, 'fan_min': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'fan_speed': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'fan_max': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'device_name': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']}

>>> read_temp(0)
{'count': 19, 'temp_max': [125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 2.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 125.0, 0.0], 've_temp': [36.125, 36.375, 36.0, 36.375, 36.5, 36.625, 36.125, 36.125, 29.0, 27.75, 33.5, 36.5, 25.75, 31.0, 32.0, 32.0, 31.0, 32.0, 31.0, 0.0], 'temp_min': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'device_name': ['ve_core0_temp', 've_core1_temp', 've_core2_temp', 've_core3_temp', 've_core4_temp', 've_core5_temp', 've_core6_temp', 've_core7_temp', 've_temp_bracket', 've_temp_adt7462', 've_temp_ve_diode_0', 've_temp_ve_diode_1', 've_temp_aux', 've_hbm0_temp', 've_hbm1_temp', 've_hbm2_temp', 've_hbm3_temp', 've_hbm4_temp', 've_hbm5_temp', '']}

>>> read_voltage(0)
{'count': 14, 'cpu_volt': [0.8875, 0.9048, 1.245699, 1.243502, 1.243502, 1.245699, 2.473822, 1.770782, 11.875, 11.8125, 3.4572, 0.89, 0.89, 0.89125, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'volt_max': [1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 4.0, 2.0, 16.0, 16.0, 4.0, 2.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'volt_min': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 'device_name': ['ve_vdd', 've_avdd', 've_hbm_e_vddc', 've_hbm_e_vddq', 've_hbm_w_vddc', 've_hbm_w_vddq', 've_vpp', 've_vddh', 've_power_edge_12v', 've_eps12v', 've_power_edge_3.3v', 've_core_vdd0', 've_core_vdd1', 've_pll_089', '', '', '', '', '', '']}

>>> stat_info(0)
{'btime': 1519312224282053L, 'processes': 270, 'softirq': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'iowait': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'hardirq': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'running': 0, 'guest': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'sys': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'idle': [18035571395L, 18381719995L, 18381772644L, 18381423124L, 18381746994L, 18381771739L, 18169013077L, 18381422057L], 'user': [449605113L, 103456497L, 103403842L, 103753357L, 103429482L, 103404732L, 316163387L, 103754403L], 'guest_nice': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'intr': 0, 'blocked': 0, 'steal': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L], 'ctxt': 262, 'nice': [0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L]}

>>> uptime_info(0)
386214.28571428574

>>> vmstat_info(0)
{'pswpout': 0L, 'pgscan_direct': 0L, 'pswpin': 0L, 'pgmajfault': 0L, 'pgfault': 0L, 'pgscan_kswapd': 0L, 'pgsteal': 0L, 'pgfree': 0L}

```
