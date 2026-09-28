#!/bin/sh
set -eu
exec az storage "$@" --connection-string "$AZURE_STORAGE_CONNECTION_STRING"
