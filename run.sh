#!/bin/bash
set -euo pipefail

credentials=""
if [[ -n "${USERNAME:-}" ]] && [[ -n "${PASSWORD:-}" ]]; then
  credentials="\&username=$USERNAME\&password=$PASSWORD"
fi

sed -i "s,^source = .*,source = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100\&params=--zeroconf-port=46807$credentials," /etc/snapserver.conf

exec snapserver
