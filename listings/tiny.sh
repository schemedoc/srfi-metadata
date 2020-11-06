#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://sourceforge.net/p/tinyscheme/code/HEAD/tree/trunk/init.scm?format=raw |
    grep -oE 'srfi-[0-9]+ ' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq > ../data/tiny.scm
