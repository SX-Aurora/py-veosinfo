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
    Extension("veosinfo",
              sources=["veosinfo" + ext],
              libraries=["veosinfo"], # Unix-like specific
              include_dirs=["/opt/nec/ve/veos/include"]
    )
]

if USE_CYTHON:
    ext_mods = cythonize(_ext_mods)
else:
    ext_mods = _ext_mods

setup(
    name = "pyVeosInfo",
    version = "1.3.2",
    ext_modules = ext_mods,
    scripts = ["veperf"],
    author = "Erich Focht",
    author_email = "efocht@gmail.com",
    license = "GPLv2",
    description = "Python bindings for the veosinfo library",
    url = "https://github.com/sx-aurora/py-veosinfo"

)
