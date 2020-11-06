#!/bin/sh

# Update SRFI info
./srfi-data.sh

# Generate and run scrapers
./listings.sh

# Scrape external libraries
./external.sh

# Generate table from above data
./table.sh

# View table
xdg-open table.html
