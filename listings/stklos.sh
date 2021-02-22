#!/bin/bash
# Auto-generated by listings.scm
set -eu -o pipefail
cd "$(dirname "$0")"
curl --fail --silent --show-error --location \
	https://github.com/egallesio/STklos/archive/stklos-1.60.tar.gz |
	gunzip |
	${TAR:-tar} -xf - --to-stdout --wildcards 'STklos-stklos-1.60/SUPPORTED-SRFIS' |
	grep -oE 'SRFI-[0-9]+:' |
	grep -oE '[0-9]+' |
	sort -g |
	uniq > ../data/stklos.scm
