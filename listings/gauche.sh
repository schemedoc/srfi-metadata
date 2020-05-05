#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/shirok/Gauche/archive/release0_9_9.tar.gz |
    gunzip |
    tar -xf - --to-stdout 'Gauche-release0_9_9/src/srfis.scm' |
    grep -oE '^srfi-[0-9]+' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >gauche.scm
