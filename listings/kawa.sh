#!/bin/bash
# Auto-generated by listings.scm
set -eu -o pipefail
cd "$(dirname "$0")"
{
    curl --location --fail --silent --show-error \
        https://gitlab.com/kashell/Kawa/-/archive/3.1.1/kawa-3.1.1.tar.gz |
        gunzip |
        ${TAR:-tar} -xf - --to-stdout --wildcards 'Kawa-3.1.1*/doc/kawa.texi' |
        grep -oE '^@uref{http://srfi.schemers.org/srfi-[0-9]+.*, ?SRFI[ -][0-9]+}:'
} | grep -oE '[0-9]+' | sort -g | uniq >../data/kawa.scm
