#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle install
bundle exec rails s -b 0.0.0.0