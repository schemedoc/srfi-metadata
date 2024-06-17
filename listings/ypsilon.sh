#!/usr/bin/env bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error -L \
    https://github.com/fujita-y/ypsilon/archive/refs/tags/v2.0.1.tar.gz |
    gunzip |
    tar -tf - |
    sed 's@%3a@@' |
    grep -oE 'sitelib/srfi/[0-9]+.scm' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq > ../data/ypsilon.scm
