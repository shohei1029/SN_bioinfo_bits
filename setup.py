#!/usr/bin/env python3

from setuptools import setup, find_packages
 
setup(
    name             = 'biwand',
    version          = '1.0.6.dev0',
    description      = 'A wand for bioinformatician. Collection of modules for dealing with biological data in Python, created by S.N.',
     #license          = __license__,
    author           = 'S.N.',
    author_email     = '',
    url              = 'https://github.com/shohei1029/biwand.git',
    keywords         = 'bioinformatics SN',
    packages         = find_packages(),
    scripts          = [
        'bin/fasta2mat_nucl.sh',
        'bin/fasta2mat_prot.sh',
        'bin/blast2sim.py',
        'bin/plot_hist.py',
        'bin/filter_blastout_evalue.sh'
        ],
    python_requires  = '>=3',
    install_requires = [
        'numpy',
        'biopython',
        'matplotlib',
        'toml',

        'pandas',
        'yapf',
        'pylint',
        'neovim',
        'ipdb',
        'progressbar2',
        'PypeR',
        'ete3',
        'tabview',
        ],
)
