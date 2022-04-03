#!/usr/bin/env bash

cd ..
REPORT_PATH=./reports/$(date +%Y-%m-%d) bundle exec rspec --format RspecHtmlReporter ./spec
git switch
