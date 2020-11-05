#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Generating listing scripts..."
gosh listings.scm

echo "Generating listing data from scripts..."
pushd listings > /dev/null
for f in *.sh; do
    echo "$f";
    ./"$f";
done
popd > /dev/null
