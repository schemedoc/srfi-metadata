#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    http://www.s48.org/1.9.2/scheme48-1.9.2.tgz |
    gunzip |
    tar -xf - --to-stdout scheme48-1.9.2/scheme/packages.scm |
    grep srfi- |
    tr -d '\t' |
    tr ' ' '\n' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >scheme48.scm
