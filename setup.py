#!/usr/bin/env python3

from setuptools import setup, find_packages
 
setup(
        name             = "SN_bioinfo_bits",
        version          = "1.0.0",
        description      = "Collection of modules for dealing with biological data in Python, created by S.N.",
#        license          = __license__,
        author           = "S.N.",
        author_email     = "",
        url              = "https://github.com/shohei1029/SN_bioinfo_bits.git",
        keywords         = ["bioinformatics", "SN"],
        packages         = find_packages(),
        install_requires = ["numpy", "biopython", "matplotlib", "toml"],
        extras_require   = ["neovim", "ipdb", "progressbar2", "PypeR", "ete3"],
        )
