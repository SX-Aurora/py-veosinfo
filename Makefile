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

RELEASE := $(shell grep -e "^release =" setup.cfg | sed -e "s,release = ,,")
DISTRO := $(shell rpm --eval "%{dist}")

rpm: veosinfo/_veosinfo.so
	python setup.py bdist_rpm --release=$(RELEASE)$(DISTRO)

srpm: veosinfo/_veosinfo.so
	python setup.py bdist_rpm --source-only

.PHONY: test clean install sdist rpm

