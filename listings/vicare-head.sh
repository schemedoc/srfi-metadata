#!/bin/bash
# Auto-generated by listings.scm
set -eu -o pipefail
cd "$(dirname "$0")"
{
    curl --location --fail --silent --show-error \
        https://github.com/marcomaggi/vicare/archive/master.tar.gz |
        gunzip |
        ${TAR:-tar} -xf - --to-stdout --wildcards 'vicare-master/doc/srfi.texi' |
        grep -oE '@ansrfi{[0-9]+}'
} | grep -oE '[0-9]+' | sort -g | uniq >../data/vicare-head.scm
