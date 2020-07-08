#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://gitlab.com/weinholt/loko/-/archive/v0.5.0/loko-v0.5.0.tar.gz |
    gunzip |
    tar -xf - --to-stdout 'loko-v0.5.0/Documentation/manual/lib-std.texi' |
    grep -oE '^@code{\(srfi :[0-9]+ ' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >loko.scm
printf '' >loko.scm
