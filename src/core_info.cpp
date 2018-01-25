#include "veosinfo.hpp"

static int wrap_ve_core_info(int nodeid)
{
	int numcore = 0;
	if (ve_mem_info(nodeid, &numcore))
		PyErr_SetString(PyExc_RuntimeError, "ve_core_info failed");
	return numcore;
}

void export_coreinfo()
{
	def("ve_core_info", &wrap_ve_core_info);
}
