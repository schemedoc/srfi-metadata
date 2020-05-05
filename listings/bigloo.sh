#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/manuel-serrano/bigloo/archive/4.3e.tar.gz |
    gunzip |
    tar -xf - --to-stdout 'bigloo-4.3e/manuals/srfi.texi' |
    grep -oE '^@item @code{srfi-[0-9]+} ' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >bigloo.scm
