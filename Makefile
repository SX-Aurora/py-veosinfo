#
# install cython in a virtualenv named cython
# workon cython
# ...
#

veosinfo.so: veosinfo.pyx
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py build_ext -i

test:
	PATHONPATH=. python test_cython.py

clean:
	rm -f *.so veosinfo.c

install:
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py install

.PHONY: test clean install

