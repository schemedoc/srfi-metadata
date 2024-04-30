#!/bin/sh
set -eu
cd "$(dirname "$0")"
rsync -vcr table.html \
    tuonela.scheme.org:/production/docs/www/srfi/support/index.html
