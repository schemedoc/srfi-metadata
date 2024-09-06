#!/usr/bin/env bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
    http://wiki.call-cc.org/supported-standards |
    grep -oE '>SRFI-[0-9]+<' |
    grep -oE '[0-9]+' |
    sort -g |
    uniq >../data/chicken.pose
