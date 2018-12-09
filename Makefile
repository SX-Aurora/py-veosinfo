#
# install cython in a virtualenv named cython
# workon cython
# ...
#

veosinfo.so: veosinfo.pyx
	python setup.py build_ext -i --use-cython

test:
	PATHONPATH=. python test_cython.py

clean:
	rm -f *.so veosinfo.c

install: veosinfo.so
	python setup.py install

sdist:
	python setup.py sdist --use-cython

rpm: veosinfo.so
	python setup.py bdist_rpm

srpm: veosinfo.so
	python setup.py bdist_rpm --source-only

.PHONY: test clean install sdist rpm

