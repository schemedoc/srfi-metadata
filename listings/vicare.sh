#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://raw.githubusercontent.com/marcomaggi/vicare/master/doc/srfi.texi |
    grep -oE '@ansrfi{[0-9]+}' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >vicare.scm
