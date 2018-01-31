
veosinfo.so: veosinfo.pyx
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py build_ext -i

test:
	PATHONPATH=. python test_cython.py


