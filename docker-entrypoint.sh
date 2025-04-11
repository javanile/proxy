#!/usr/bin/env sh

echo "Starting up the application..."

lighttpd -f /etc/lighttpd/lighttpd.conf

exec "$@"
