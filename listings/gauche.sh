#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/shirok/Gauche/releases/download/release0_9_9/Gauche-0.9.9.tgz |
    gunzip |
    tar -xf - --to-stdout Gauche-0.9.9/doc/modsrfi.texi |
    grep -ohE 'srfi-[0-9]+' |
    sed 's@srfi-@@' |
    sort -g |
    uniq >gauche.scm
