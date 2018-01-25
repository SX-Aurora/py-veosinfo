#include "veosinfo.hpp"

//
// this is an example for a _to_python converter
//
struct char_array_conv255 {
	static PyObject* convert(char x[255]) {
		return PyString_FromString(&x[0]);
	}
};

void export_archinfo();
void export_coreinfo();
void export_cpuinfo();
void export_get_nodes();
void export_loadavginfo();
void export_meminfo();
void export_nodeinfo();
void export_statinfo();
void export_uptime_info();


BOOST_PYTHON_MODULE(veosinfo)
{
	//to_python_converter<char[255], char_array_conv255, false>();

	export_archinfo();
        export_coreinfo();
	export_cpuinfo();
	export_get_nodes();
	export_loadavginfo();
        export_meminfo();
	export_nodeinfo();
        export_statinfo();
	export_uptime_info();
}

