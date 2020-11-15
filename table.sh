#!/bin/sh
set -eu
echo "Creating table from collected data..."
cd "$(dirname "$0")"
racket table.rkt > table.html
echo "Created."
