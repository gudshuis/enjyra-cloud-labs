#!/bin/sh
set -eu
exec gcloud storage "$@"
