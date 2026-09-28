#!/bin/sh
set -eu
exec aws --endpoint-url=http://emulator:4566 --region us-east-1 "$@"
