#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
cd ..
pwd
echo "Generating Reports"
REPORT_PATH=./reports bundle exec rspec --format RspecHtmlReporter ./spec
echo "Swapping branches"
git switch gh-pages
pwd
sleep 
echo "Committing reports to git"
git add ./reports
git commit
git push
git switch main
