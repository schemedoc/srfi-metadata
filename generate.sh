#!/bin/sh
set -eu
cd "$(dirname "$0")"
./srfi-data.sh       # Update SRFI info
echo
./listings.sh        # Generate and run scrapers
echo
./external.sh        # Scrape external libraries
echo
./table.sh           # Generate table from above data
echo
echo "Done!"
${OPEN:-xdg-open} table.html  # View table
