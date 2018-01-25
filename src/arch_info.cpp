#include "veosinfo.hpp"

static dict ArchInfo(int nodeid) {
	struct ve_archinfo va;
	if (ve_arch_info(nodeid, &va))
		PyErr_SetString(PyExc_RuntimeError, "ve_arch_info failed");

	dict d;
	d["machine"] = std::string(&(va.machine[0]));
	d["processor"] = std::string(&(va.processor[0]));
	d["hw_platform"] = std::string(&(va.hw_platform[0]));
	return d;
}

void export_archinfo()
{
	def("ve_arch_info", &ArchInfo);
}
