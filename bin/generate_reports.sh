#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
cd ..
pwd
echo "Generating Reports"
REPORT_PATH=./reports bundle exec rspec --format RspecHtmlReporter ./spec
echo "Swapping branches"
git switch gh-pages
echo "Committing reports to git"
pwd
git commit ./reports
git push
git switch main
