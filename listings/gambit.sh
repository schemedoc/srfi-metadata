#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://raw.githubusercontent.com/gambit/gambit/master/lib/srfi/makefile |
    grep '^SUBDIRS = ' |
    sed 's@SUBDIRS = @@' |
    tr ' ' '\n' |
    sort -g |
    uniq >gambit.scm
