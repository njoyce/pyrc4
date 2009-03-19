# Copyright (c) 2007-2009 The PyAMF Project.
# See LICENSE for details.

from ez_setup import use_setuptools

use_setuptools()

import sys
from setuptools import setup, find_packages, Extension
from setuptools.command import test

try:
    from Cython.Distutils import build_ext
except ImportError:
    from setuptools.command.build_ext import build_ext

def get_extensions():
    """
    """
    return [
        Extension('pyrc4', ['pyrc4.pyx'],
            libraries=['ssl'],
        )
    ]

def get_install_requirements():
    """
    Returns a list of dependancies for PyAMF to function correctly on the
    target platform
    """
    install_requires = []

    return install_requires


setup(name = "PyRC4",
    version = '0.0.1',
    description = "Thin wrapper over OpenSSL's RC4 for Python",
    ext_modules = get_extensions(),
    install_requires = get_install_requirements(),
    zip_safe = True,
    license = "MIT License",
    platforms = ["any"],
    cmdclass = {
        'build_ext': build_ext,
    },
    classifiers = [
    ]
)
