#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Updating SRFI data..."
curl --fail --silent --show-error -o data/srfi-data.scm https://raw.githubusercontent.com/scheme-requests-for-implementation/srfi-common/master/admin/srfi-data.scm
echo "Updated."
