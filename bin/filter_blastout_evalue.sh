#!/bin/sh
set -euo pipefail

EVALUE=$1

if [ "$1" = "" ]; then
    EVALUE=1e-5
fi

grep -v "#" </dev/stdin | perl -F"\\t" -lane 'print if $F[10] <= $var' -- -var=${EVALUE}
