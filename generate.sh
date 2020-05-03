#!/bin/sh
set -eu
cd "$(dirname "$0")"
racket generate.rkt >table.html
