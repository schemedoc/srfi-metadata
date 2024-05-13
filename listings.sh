#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Generating scraper scripts..."
gosh listings.scm
echo "Generated."
echo
echo "Scraping listing data..."
cd listings
chmod +x ./*.sh
for f in *.sh; do
    echo "$f";
    ./"$f";
done
cd ..
echo "Scraped."
