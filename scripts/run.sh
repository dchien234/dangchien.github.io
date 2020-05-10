#!/usr/bin/env bash
set -e

me="$(basename "$0")"
mydir="$(dirname "$0")"

# check if bundle is installed
if ! [[ -x "$(command -v bundle)" ]]; then
  echo 'ERROR: bundle is not installed.' >&2
  exit 1
fi

# check if we need to install new/updated packages
if [[ ! $(bundle check) ]]; then
  bundle install
fi

echo "$me" "$mydir"

# clean the build dir
bundle exec jekyll clean

# serve the blog in incremental development mode
#bundle exec jekyll serve --incremental
bundle exec jekyll serve --incremental --drafts
