#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://raw.githubusercontent.com/vyzo/gerbil/master/doc/guide/srfi.md |
    grep -oE '\[SRFI +[0-9]+\]' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >gerbil.scm
