#!/usr/bin/env bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    "http://cvs.savannah.gnu.org/viewvc/*checkout*/slib/slib/slib.texi" |
    grep -E 'srfi-[0-9]+' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq > ../data/slib.scm
