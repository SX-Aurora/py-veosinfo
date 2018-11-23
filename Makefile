#
# install cython in a virtualenv named cython
# workon cython
# ...
#

veosinfo.so: veosinfo.pyx
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py build_ext -i --use-cython

test:
	PATHONPATH=. python test_cython.py

clean:
	rm -f *.so veosinfo.c

install: veosinfo.so
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py install

sdist:
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py sdist --use-cython

rpm: veosinfo.so
	CFLAGS="-I/opt/nec/ve/veos/include" LDFLAGS="-L/opt/nec/ve/veos/lib64" python setup.py bdist_rpm

.PHONY: test clean install sdist rpm

