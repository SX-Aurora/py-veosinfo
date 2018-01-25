#include "veosinfo.hpp"

static dict wrap_ve_loadavg_info(int nodeid)
{
	struct ve_loadavg la;
	if (ve_loadavg_info(nodeid, &la))
		PyErr_SetString(PyExc_RuntimeError, "ve_loadavg_info failed");

        dict d;
        d["av_1"] = la.av_1;
        d["av_5"] = la.av_5;
        d["av_15"] = la.av_15;
        d["runnable"] = la.runnable;
        d["total_proc"] = la.total_proc;
        return d;
}

void export_loadavginfo()
{
	def("ve_loadavg_info", &wrap_ve_loadavg_info);
}
