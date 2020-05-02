#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://raw.githubusercontent.com/texmacs/guile/master/doc/ref/srfi-modules.texi |
    grep -E '^\* SRFI-[0-9]+::' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >guile.scm
