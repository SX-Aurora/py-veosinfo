#
# install cython in a virtualenv named cython
# workon cython
# ...
#

veosinfo/_veosinfo.so: veosinfo/_veosinfo.pyx
	python setup.py build_ext -i --use-cython

test:
	PATHONPATH=. python test_veosinfo.py

clean:
	rm -f veosinfo/*.so veosinfo/_veosinfo.c veosinfo/*.pyc

install: veosinfo/_veosinfo.so
	python setup.py install

sdist:
	python setup.py sdist --use-cython

upload:
	python -m twine upload dist/py-veosinfo*.tar.gz

rpm: veosinfo/_veosinfo.so
	python setup.py bdist_rpm

srpm: veosinfo/_veosinfo.so
	python setup.py bdist_rpm --source-only

.PHONY: test clean install sdist rpm

