#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/manuel-serrano/bigloo/archive/master.tar.gz |
    gunzip |
    tar -xf - --to-stdout 'bigloo-master/manuals/srfi.texi' |
    grep -ohE '^@item @code{srfi-[0-9]+} ' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >bigloo-head.scm
