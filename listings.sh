#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Generating scraper scripts..."
gosh listings.scm
echo "Generated."
echo
echo "Scraping listing data..."
pushd listings > /dev/null
for f in *.sh; do
    echo "$f";
    ./"$f";
done
popd > /dev/null
echo "Scraped."
