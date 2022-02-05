#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error -L \
    https://github.com/fujita-y/ypsilon/archive/master.tar.gz |
    gunzip |
    tar -tf - |
    sed 's@%3a@@' |
    grep sitelib/srfi/ |
    grep -oE '[0-9]+.scm' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq > ../data/ypsilon-head.scm
