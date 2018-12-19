#
# install cython in a virtualenv named cython
# workon cython
# ...
#

veosinfo/_veosinfo.so: veosinfo/_veosinfo.pyx
	python setup.py build_ext -i --use-cython

test:
	PATHONPATH=. python test_cython.py

clean:
	rm -f veosinfo/*.so veosinfo/_veosinfo.c veosinfo/*.pyc

install: veosinfo/_veosinfo.so
	python setup.py install

sdist:
	python setup.py sdist --use-cython

rpm: veosinfo/_veosinfo.so
	python setup.py bdist_rpm

srpm: veosinfo/_veosinfo.so
	python setup.py bdist_rpm --source-only

.PHONY: test clean install sdist rpm

