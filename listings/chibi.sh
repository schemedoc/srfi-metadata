#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    http://synthcode.com/scheme/chibi/chibi-scheme-0.8.0.tgz |
    gunzip |
    tar -tf - |
    grep -i 'chibi-scheme-[0-9.]*/lib/srfi/[0-9]*.sld' |
    sed -e 's@.*/@@' -e s@.sld@@ |
    sort -g |
    uniq >chibi.scm
