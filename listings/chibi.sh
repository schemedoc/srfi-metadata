#!/bin/bash
# Auto-generated by listings.scm
set -eu -o pipefail
cd "$(dirname "$0")"
{
    echo 0
    curl --location --fail --silent --show-error \
        https://github.com/ashinn/chibi-scheme/archive/0.9.1.tar.gz |
        gunzip |
        ${TAR:-tar} -tf - |
        grep -oE 'chibi-scheme-0.9.1/lib/srfi/[0-9]+.sld' |
        sed 's@[^/]*/@@' |
        sed 's@%3a@@'
} | grep -oE '[0-9]+' | sort -g | uniq >../data/chibi.scm
