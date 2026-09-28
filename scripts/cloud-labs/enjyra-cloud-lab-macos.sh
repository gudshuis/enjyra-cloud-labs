#!/bin/bash
# ENJYRA Cloud Labs — macOS launcher.
# Usage: ./scripts/cloud-labs/enjyra-cloud-lab-macos.sh <aws|azure|gcp> <start|status|cli|reset|logs|stop> [CLI args]
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
LAUNCHER_NAME="./scripts/cloud-labs/enjyra-cloud-lab-macos.sh"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This launcher is written for macOS. On Linux use enjyra-cloud-lab-linux.sh; on Windows use enjyra-cloud-lab.ps1." >&2
fi

# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"
main "$@"
