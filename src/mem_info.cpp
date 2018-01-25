#include "veosinfo.hpp"

static dict wrap_ve_mem_info(int nodeid)
{
	struct ve_meminfo m;
	if (ve_mem_info(nodeid, &m))
		PyErr_SetString(PyExc_RuntimeError, "ve_mem_info failed");

	dict d;

        d["kb_main_total"] = m.kb_main_total;
        d["kb_main_used"] = m.kb_main_used;
        d["kb_main_free"] = m.kb_main_free;
        d["kb_main_shared"] = m.kb_main_shared;
        d["kb_main_buffers"] = m.kb_main_buffers;
        d["kb_main_cached"] = m.kb_main_cached;
        d["kb_swap_cached"] = m.kb_swap_cached;
        d["kb_low_total"] = m.kb_low_total;
        d["kb_low_free"] = m.kb_low_free;
        d["kb_high_total"] = m.kb_high_total;
        d["kb_high_free"] = m.kb_high_free;
        d["kb_swap_total"] = m.kb_swap_total;
        d["kb_swap_free"] = m.kb_swap_free;
        d["kb_active"] = m.kb_active;
        d["kb_inactive"] = m.kb_inactive;
        d["kb_dirty"] = m.kb_dirty;
        d["kb_committed_as"] = m.kb_committed_as;
        d["hugepage_total"] = m.hugepage_total;
        d["hugepage_free"] = m.hugepage_free;
        d["kb_hugepage_used"] = m.kb_hugepage_used;
        return d;
}

void export_meminfo()
{
	def("ve_mem_info", &wrap_ve_mem_info);
}
