#!/usr/bin/env bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://cgit.git.savannah.gnu.org/cgit/guile.git/plain/doc/ref/srfi-modules.texi |
    grep -E '^\* SRFI-[0-9]+::' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >../data/guile.pose
