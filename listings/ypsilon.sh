#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ypsilon/ypsilon-0.9.6.update3.tar.gz |
    gunzip |
    tar -tf - |
    sed 's@%3a@@' |
    grep sitelib/srfi/ |
    grep -oE '[0-9]+.scm' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq > ../data/ypsilon.scm
