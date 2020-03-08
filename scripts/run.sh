#!/usr/bin/env bash
set -e

#cd "$(dirname "$0")"

# check if bundle is installed
if ! [[ -x "$(command -v bundle)" ]]; then
    echo 'ERROR: bundle is not installed.' >&2
    exit 1
fi

# check if we need to install new/updated packages
if [[ $(bundle check | wc -l) -gt 1 ]]; then
    bundle install
fi

# serve the blog in incremental development mode
bundle exec jekyll clean
#bundle exec jekyll serve --incremental
bundle exec jekyll serve --incremental --drafts
