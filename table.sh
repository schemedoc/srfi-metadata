#!/bin/sh
set -eu
cd "$(dirname "$0")"
racket table.rkt >table.html
