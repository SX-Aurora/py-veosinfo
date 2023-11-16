# Most targets are expected to be built inside a virtualenv,
# its building as well as restarting make in it is automated.

ifeq ($(VIRTUAL_ENV),)

# If virtual environment is not active, restart within virtual environment
SELF := $(MAKE) -f $(lastword $(MAKEFILE_LIST))
MAKE := $(shell echo $$MAKE)

in_venv: | venv
	@echo "Virtual environment not active. Restarting within virtual environment..."
	@echo "MAKECMDGOALS = $(MAKECMDGOALS)"
	. venv/bin/activate && $(SELF) $(MAKEFLAGS) $(MAKECMDGOALS)

sdist rpm srpm upload: in_venv

else

veosinfo/_veosinfo.so: in_venv veosinfo/_veosinfo.pyx
	python setup.py build_ext -i --use-cython

.PHONY: sdist upload
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

endif

.PHONY: test clean install
test:
	PYTHONPATH=. python test_veosinfo.py

clean:
	rm -f veosinfo/*.so veosinfo/_veosinfo.c veosinfo/*.pyc

install: veosinfo/_veosinfo.so
	python setup.py install

venv:
	python3 -m venv venv && \
	. venv/bin/activate && \
	pip install -U pip && \
	pip install -r requirements.txt
