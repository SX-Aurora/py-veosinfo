#!/usr/bin/python

from veosinfo import *
import os, time

ni = node_info()
print "node_info() : ", ni

nid = ni["nodeid"][0]

print "arch_info(%d) : %r\n" % (nid, arch_info(nid))

#pid = os.getpid()
#print "create_pocess(%d, %d, 0) : %r\n" % (nid, pid, create_process(nid, pid, 0))
#
#print "check_pid(%d, %d) : %r\n" % (nid, pid, check_pid(nid, pid))
#
#print "pidstat_info(%d, %d) : %r\n" % (nid, pid, pidstat_info(nid, pid))
#
#time.sleep(10)
#
##
## after creating a process
## Couldn't open file (/dev/veslot0): Device or resource busy
## Failed to get VE sysfs path: Device or resource busy
##

print "node_info() : ", node_info()

print "core_info(%d) : %r\n" % (nid, core_info(nid))

print "cpu_info(%d) : %r\n" % (nid, cpu_info(nid))

print "cpufreq_info(%d) : %r\n" % (nid, cpufreq_info(nid))

print "loadavg_info(%d) : %r\n" % (nid, loadavg_info(nid))

print "mem_info(%d) : %r\n" % (nid, mem_info(nid))

print "read_fan(%d) : %r\n" % (nid, read_fan(nid))

print "read_temp(%d) : %r\n" % (nid, read_temp(nid))

print "read_voltage(%d) : %r\n" % (nid, read_voltage(nid))

print "stat_info(%d) : %r\n" % (nid, stat_info(nid))

print "uptime_info(%d) : %r\n" % (nid, uptime_info(nid))

print "vmstat_info(%d) : %r\n" % (nid, vmstat_info(nid))

