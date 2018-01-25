#include "veosinfo.hpp"

using namespace std;

static dict CpuInfo(int nodeid)
{
	dict d;
	struct ve_cpuinfo ci;
	if (ve_cpu_info(nodeid, &ci))
		PyErr_SetString(PyExc_RuntimeError, "ve_cpu_info failed");
	d["cores"] = ci.cores;
	d["thread_per_core"] = ci.thread_per_core;
	d["core_per_socket"] = ci.core_per_socket;
	d["socket"] = ci.socket;
	d["vendor"] = string(ci.vendor);
	d["family"] = string(ci.family);
	d["model"] = string(ci.model);
	d["modelname"] = string(ci.modelname);
	d["mhz"] = std::stod(string(ci.mhz));
	d["stepping"] = string(ci.stepping);
	d["bogomips"] = string(ci.bogomips);
	d["nnodes"] = ci.nnodes;
	d["op_mode"] = string(ci.op_mode);
	list cn, cs;
	for (int i = 0; i < VE_MAX_CACHE; i++) {
		cn.append(string(ci.cache_name[i]));
		cs.append(ci.cache_size[i]);
	}
	d["cache_name"] = cn;
	d["cache_size"] = cs;
	return d;
}


void export_cpuinfo()
{
	def("ve_cpu_info", &CpuInfo);
}
