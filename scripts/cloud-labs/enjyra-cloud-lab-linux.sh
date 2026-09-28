#!/bin/bash
# ENJYRA Cloud Labs — Linux launcher. Works regardless of distribution/package manager;
# it only requires Docker and the docker compose plugin to already be installed.
# Usage: ./scripts/cloud-labs/enjyra-cloud-lab-linux.sh <aws|azure|gcp> <start|status|cli|reset|logs|stop> [CLI args]
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
LAUNCHER_NAME="./scripts/cloud-labs/enjyra-cloud-lab-linux.sh"

if [ "$(uname -s)" != "Linux" ]; then
  echo "This launcher is written for Linux. On macOS use enjyra-cloud-lab-macos.sh; on Windows use enjyra-cloud-lab.ps1." >&2
fi

# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"
main "$@"
