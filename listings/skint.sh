#!/usr/bin/env bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error -L \
    https://github.com/false-schemers/skint/archive/refs/heads/main.tar.gz |
    gunzip |
    tar -tf - |
    grep -oE 'lib/srfi/[0-9]+.sld' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >../data/skint.pose
