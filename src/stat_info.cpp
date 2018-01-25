#include "veosinfo.hpp"

static dict wrap_ve_stat_info(int nodeid)
{
	struct ve_statinfo si;
	if (ve_stat_info(nodeid, &si))
		PyErr_SetString(PyExc_RuntimeError, "ve_stat_info failed");

	dict d;
	d["intr"] = si.intr;
	d["ctxt"] = si.ctxt;
	d["running"] = si.running;
	d["blocked"] = si.blocked;
	d["btime"] = si.btime;
	d["processes"] = si.processes;
        list c;
        for (int i = 0; i < VE_MAX_CORE_PER_NODE; i++) {
		dict e;
		// ignore non-existent or disabled cores
		if (si.user[i] == 0 && si.nice[i] == 0 && si.idle[i] == 0)
			break;
		e["user"] = si.user[i];
		e["nice"] = si.nice[i];
		e["idle"] = si.idle[i];
		e["iowait"] = si.iowait[i];
		e["sys"] = si.sys[i];
		e["hardirq"] = si.hardirq[i];
		e["softirq"] = si.softirq[i];
		e["steal"] = si.steal[i];
		e["guest"] = si.guest[i];
		e["guest_nice"] = si.guest_nice[i];
		c.append(e);
	}
	d["core"] = c;
	return d;
}

void export_statinfo()
{
	def("ve_stat_info", &wrap_ve_stat_info);
}
