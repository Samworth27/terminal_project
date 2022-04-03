#!/usr/bin/env bash

cd ..

REPORT_PATH=./reports/$(date +%Y-%m-%d) bundle exec rspec --format RspecHtmlReporter ./spec
git switch gh-pages
git commit ./reports
git push
git switch main
