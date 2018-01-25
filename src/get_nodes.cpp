#include "veosinfo.hpp"

boost::python::list wrap_ve_get_nos()
{
	unsigned int online;
	int nodeid[VE_MAX_NODE];
	if (!ve_get_nos(&online, nodeid)) {
		boost::python::list l;
		for (int i = 0; i < online; i++)
			l.append(nodeid[i]);
		return l;
	}
	PyErr_SetString(PyExc_RuntimeError, "ve_get_nos failed");
}

void export_get_nodes()
{
	def("ve_get_nodes", &wrap_ve_get_nos);
}
