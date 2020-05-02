#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://gitlab.com/kashell/Kawa/-/raw/master/doc/kawa.texi |
    grep -E '^@uref{http://srfi.schemers.org/srfi-[0-9]+/srfi-[0-9]+.html, SRFI [0-9]+}: ' |
    grep -oE 'SRFI [0-9]+' |
    sed 's@SRFI @@' |
    sort -g |
    uniq >kawa.scm
