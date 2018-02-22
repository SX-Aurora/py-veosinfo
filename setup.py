from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

ext_modules=[
    Extension("veosinfo",
              sources=["veosinfo.pyx"],
              libraries=["veosinfo"], # Unix-like specific
              include_dirs=["/opt/nec/ve/veos/include"]
    )
]

setup(
    name = "pyVeosInfo",
    version = "1.0",
    ext_modules = cythonize(ext_modules)
    packages = ["veosinfo"],
    author = "Erich Focht",
    author_email = "efocht@gmail.com",
    license = "GPLv2",
    description = "Python bindings for the veosinfo library",
    url = "https://github.com/aurora-ve/py-veosinfo"

)
