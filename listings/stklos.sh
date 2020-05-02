#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://raw.githubusercontent.com/egallesio/STklos/master/doc/skb/srfi.stk |
    grep -oE '^ +\([0-9]+ +\. "' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >stklos.scm
