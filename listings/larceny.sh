#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
    https://github.com/larcenists/larceny/archive/master.tar.gz |
    gunzip |
    tar -tf - |
    sed 's@%3a@@' |
    grep -E 'srfi.[0-9]+\.s' |
    grep -v in-progress |
    grep -oE 'srfi.[0-9]+' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq > ../data/larceny.scm
