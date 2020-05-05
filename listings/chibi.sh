#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/ashinn/chibi-scheme/archive/0.8.tar.gz |
    gunzip |
    tar -tf - |
    grep -oE 'chibi-scheme-0.8/lib/srfi/[0-9]+.sld' |
    sed 's@%3a@@' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >chibi.scm
