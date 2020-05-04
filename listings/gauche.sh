#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/shirok/Gauche/releases/download/release0_9_9/Gauche-0.9.9.tgz |
    gunzip |
    tar -xf - --to-stdout Gauche-0.9.9/doc/srfis.texi |
    grep -ohE '^@item SRFI-[0-9]+' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >gauche.scm
