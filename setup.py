import sys
from distutils.core import setup
from distutils.extension import Extension

USE_CYTHON = False
ext = ".c"
if "--use-cython" in sys.argv:
    from Cython.Build import cythonize
    sys.argv.remove("--use-cython")
    USE_CYTHON = True
    ext = ".pyx"

_ext_mods=[
    Extension("veosinfo._veosinfo",
              sources=["veosinfo/_veosinfo" + ext],
              libraries=["veosinfo"], # Unix-like specific
              library_dirs=["veosinfo", "/opt/nec/ve/veos/lib64"],
              include_dirs=["veosinfo", "/opt/nec/ve/veos/include"]
    )
]

if USE_CYTHON:
    ext_mods = cythonize(_ext_mods)
else:
    ext_mods = _ext_mods

_long_descr = """
Python bindings to libveosinfo that provides various details
on the SX-Aurora Vector Engines located in the current host:
- lists VEs in the system and their state
- information in the VE architecture
- information on caches, frequencies of each VE core
- load and memory statistics of VEs
- information on processes running on the VEs
- fan, temperature, voltage of VEs
- various statistical infos
- a mechanism to read VE register values of own processes

The tool veperf can be used to periodically display performance metrics of
the own VE processes.
"""
    
setup(
    name = "py-veosinfo",
    version = "2.6.1",
    ext_modules = ext_mods,
    scripts = ["veperf"],
    author = "Erich Focht",
    author_email = "efocht@gmail.com",
    license = "GPLv2",
    description = "Python bindings for the veosinfo library for the SX-Aurora Vector Engine",
    long_description = _long_descr,
    long_description_content_type = "text/markdown",
    packages = [ "veosinfo" ],
    data_files = [("share/py-veosinfo", ["README.md"])],
    url = "https://github.com/sx-aurora/py-veosinfo",
    classifiers=[
      'Development Status :: 5 - Production/Stable',
      'Environment :: Console',
      'Intended Audience :: Education',
      'Intended Audience :: Developers',
      'Intended Audience :: Science/Research',
      'License :: OSI Approved :: GNU General Public License (GPL)',
      'Operating System :: POSIX :: Linux',
      'Programming Language :: Python',
      'Topic :: Software Development :: Libraries :: Python Modules',
      'Topic :: System :: Monitoring',
      'Topic :: Utilities'
      ]
)
