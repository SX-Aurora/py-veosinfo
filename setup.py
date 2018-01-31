from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

ext_modules=[
    Extension("veosinfo",
              sources=["veosinfo.pyx"],
              libraries=["veosinfo"] # Unix-like specific
    )
]

setup(
  name = "Veosinfo",
  ext_modules = cythonize(ext_modules)
)
