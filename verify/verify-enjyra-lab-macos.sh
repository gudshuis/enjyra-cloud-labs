#!/bin/bash
# ENJYRA Cloud Labs — macOS download/tool verification.
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
FAIL=0
warn() { echo "WARNING: $1"; }
fail() { echo "FAIL: $1"; FAIL=1; }
pass() { echo "PASS: $1"; }

echo "== Checksums =="
if [ -f "$REPO_ROOT/checksums.txt" ]; then
  cd "$REPO_ROOT"
  if shasum -a 256 -c checksums.txt --status 2>/tmp/enjyra-verify-err; then
    pass "All files match checksums.txt"
  else
    fail "One or more files do not match checksums.txt"
    cat /tmp/enjyra-verify-err
  fi
  fingerprint=$(shasum -a 256 checksums.txt | awk '{print $1}')
  echo "Release fingerprint (SHA-256 of checksums.txt): $fingerprint"
else
  warn "checksums.txt not found — skipping integrity check"
fi

echo "== Tools =="
if command -v docker >/dev/null 2>&1; then
  pass "Docker found: $(docker --version)"
else
  fail "Docker not found. Install: https://docs.docker.com/get-docker/"
fi

if docker compose version >/dev/null 2>&1; then
  pass "Docker Compose plugin found: $(docker compose version)"
else
  fail "Docker Compose plugin not found."
fi

if command -v git >/dev/null 2>&1; then
  pass "Git found: $(git --version)"
else
  fail "Git not found. Install: https://git-scm.com/downloads"
fi

if command -v python3 >/dev/null 2>&1; then
  pass "Python found: $(python3 --version)"
else
  warn "python3 not found on PATH (not required to run the labs themselves)"
fi

if command -v code >/dev/null 2>&1; then
  pass "VS Code CLI found: $(code --version | head -1)"
else
  warn "VS Code 'code' command not on PATH — this is common even when VS Code is installed correctly; not required to run the labs."
fi

echo "== Launcher =="
if [ -x "$REPO_ROOT/scripts/cloud-labs/enjyra-cloud-lab-macos.sh" ]; then
  pass "enjyra-cloud-lab-macos.sh is present and executable"
else
  fail "enjyra-cloud-lab-macos.sh missing or not executable"
fi

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "Integrity: FAILED — see FAIL lines above."
  exit 1
fi
echo ""
echo "Integrity: VERIFIED"
