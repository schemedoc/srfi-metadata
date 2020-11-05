#!/bin/sh
set -eu
cd "$(dirname "$0")"
curl --fail --silent --show-error -o data/srfi-data.scm https://raw.githubusercontent.com/scheme-requests-for-implementation/srfi-common/master/admin/srfi-data.scm
