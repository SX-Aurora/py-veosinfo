#!/usr/bin/python

import sys
sys.path.insert(0, '.')

from veosinfo import *

#--------------------
# implemented
#
# int ve_arch_info(int, struct ve_archinfo *);
# int ve_core_info(int, int *);
# int ve_cpu_info(int, struct ve_cpuinfo *);
# int ve_get_nos(unsigned int *, int *);
# int ve_loadavg_info(int, struct ve_loadavg *);
# int ve_mem_info(int, struct ve_meminfo *);
# int ve_node_info(struct ve_nodeinfo *);
# int ve_stat_info(int, struct ve_statinfo *);
# int ve_uptime_info(int, double *);


#---------------------
# not implemented
#
# int ve_create_process(int, int, int);
# int ve_check_pid(int, int);
# int ve_acct(int, char *);
# int ve_prlimit(int, pid_t, int, struct rlimit *, struct rlimit *);
# int ve_sched_getaffinity(int, pid_t, size_t, cpu_set_t *);
# int ve_sched_setaffinity(int, pid_t, size_t, cpu_set_t *);
# int ve_pidstat_info(int, pid_t, struct ve_pidstat *);
# int ve_map_info(int, pid_t, struct ve_mapheader *);
# int ve_vmstat_info(int, struct ve_vmstat *);
# int ve_pidstatus_info(int, pid_t, struct ve_pidstatus *);
# int ve_pidstatm_info(int, pid_t, struct ve_pidstatm *);
# int ve_get_rusage(int, pid_t, struct ve_get_rusage_info *);
# int ve_read_fan(int, struct ve_pwr_fan *);
# int ve_read_temp(int, struct ve_pwr_temp *);
# int ve_read_voltage(int, struct ve_pwr_voltage *);
# int ve_cpufreq_info(int, unsigned long *);

nodes = ve_get_nodes()
print "VE nodes: %r\n" % nodes

if len(nodes) == 0:
    print "no VE nodes online. exiting."
    sys.exit()

nodeid = nodes[0]

print "ve_node_info() = %r\n" % ve_node_info()

print "ve_arch_info(%d) = %r\n" % (nodeid, ve_arch_info(nodeid))

print "ve_uptime_info(%d) = %r\n" % (nodeid, ve_uptime_info(nodeid))

print "ve_loadavg_info(%d) = %r\n" % (nodeid, ve_loadavg_info(nodeid))

print "ve_cpu_info(%d) = %r\n" % (nodeid, ve_cpu_info(nodeid))

print "ve_mem_info(%d) = %r\n" % (nodeid, ve_mem_info(nodeid))

print "ve_stat_info(%d) = %r\n" % (nodeid, ve_stat_info(nodeid))

print "----- finished -----"
