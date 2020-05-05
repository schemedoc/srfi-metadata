#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/shirok/Gauche/archive/master.tar.gz |
    gunzip |
    tar -xf - --to-stdout 'Gauche-master/src/srfis.scm' |
    grep -ohE '^srfi-[0-9]+' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >gauche-head.scm
