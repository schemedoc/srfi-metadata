#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://gitlab.com/weinholt/loko/-/raw/master/Documentation/manual/lib-std.texi |
    grep -oE '^@code{\(srfi :[0-9]+ ' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >loko.scm
