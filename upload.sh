#!/bin/sh
set -eu
cd "$(dirname "$0")"
rsync table.html scheme.org:/production/docs/www/srfi/support/index.html
