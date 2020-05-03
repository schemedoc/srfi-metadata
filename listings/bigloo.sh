#!/bin/bash
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error \
	https://raw.githubusercontent.com/manuel-serrano/bigloo/master/manuals/srfi.texi |
	grep -oE '^@item @code{srfi-[0-9]+} ' |
	grep -oE '[0-9]+' |
	sort -g |
	uniq >bigloo.scm
