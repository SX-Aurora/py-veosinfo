#include "veosinfo.hpp"

double wrap_ve_uptime_info(int venode)
{
	double res = 0.;
	if (!ve_uptime_info(venode, &res))
		return res;
	PyErr_SetString(PyExc_RuntimeError, "ve_uptime_info failed");
}

void export_uptime_info()
{
	def("ve_uptime_info", &wrap_ve_uptime_info);
}
