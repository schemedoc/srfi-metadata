#!/bin/bash
# Auto-generated by listings.scm
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
	https://github.com/ktakashi/sagittarius-scheme/archive/master.tar.gz |
	gunzip |
	tar -xf - --to-stdout --wildcards 'sagittarius-scheme-master/doc/srfi.scrbl' |
	grep -oE '\(srfi :[0-9]+[ )]' |
	grep -oE '[0-9]+' |
	sort -g |
	uniq > ../data/sagittarius-head.scm
