#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/ashinn/chibi-scheme/archive/master.tar.gz |
    gunzip |
    tar -tf - |
    grep -ohE 'chibi-scheme-master/lib/srfi/[0-9]+.sld' |
    sed 's@%3a@@' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >chibi-head.scm
