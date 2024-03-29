#!/bin/bash
# Auto-generated by listings.scm
set -eu -o pipefail
cd "$(dirname "$0")"
{
    echo 0
    echo 7
    echo 46
    curl --location --fail --silent --show-error \
        https://gitlab.com/nieper/unsyntax/-/archive/v0.0.3/unsyntax-v0.0.3.tar.gz |
        gunzip |
        ${TAR:-tar} -tf - |
        sed 's@[^/]*/@@' |
        grep -oE 'src/srfi/[0-9]+.s.?.?' |
        sed 's@%3a@@'
} | grep -oE '[0-9]+' | sort -g | uniq >../data/unsyntax.scm
