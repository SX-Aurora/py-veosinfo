#include "veosinfo.hpp"

static dict wrap_ve_node_info()
{
	struct ve_nodeinfo ni;
	if (ve_node_info(&ni))
		PyErr_SetString(PyExc_RuntimeError, "ve_node_info failed");

	dict d;
	list nodeid, status, cores;
	for (int i = 0; i < ni.total_node_count; i++) {
		dict c;
		c["status"] = ni.status[i];
		c["cores"] = ni.cores[i];
		d[ni.nodeid[i]] = c;
	}
	return d;
}

void export_nodeinfo()
{
	def("ve_node_info", &wrap_ve_node_info);
}
