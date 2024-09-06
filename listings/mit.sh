#!/usr/bin/env bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    https://git.savannah.gnu.org/cgit/mit-scheme.git/plain/etc/standards/standards.scm |
    grep -ioE "(srfi [0-9]+)" |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >../data/mit.pose
