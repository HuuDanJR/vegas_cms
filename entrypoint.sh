#!/bin/bash
set -e

# Install node modules
cd /app && yarn install --check-files

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
