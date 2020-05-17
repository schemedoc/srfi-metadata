#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://bitbucket.org/ktakashi/sagittarius-scheme/raw/master/doc/srfi.scrbl |
    grep -oE '\(srfi :[0-9]+[ )]' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >sagittarius.scm
