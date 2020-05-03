#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
	"https://docs.racket-lang.org/srfi/index.html?q=srfi" |
	grep -oE '<a href="srfi-[0-9]+.html"' |
	grep -oE '[0-9]+' |
	sort -g |
	uniq >racket.scm
