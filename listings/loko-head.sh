#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/weinholt/loko/archive/master.tar.gz |
    gunzip |
    tar -xf - --to-stdout 'loko-master/Documentation/manual/lib-std.texi' |
    grep -ohE '^@code{\(srfi :[0-9]+ ' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >loko-head.scm
