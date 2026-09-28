#!/bin/sh
# Shared logic for the macOS and Linux launchers. Not meant to be run directly.
# Expects REPO_ROOT to already be set by the caller (resolved from its own script location).
set -eu

usage() {
  echo "Usage: $LAUNCHER_NAME <aws|azure|gcp> <start|status|cli|reset|logs|stop> [CLI arguments]" >&2
  exit 2
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    echo "$2" >&2
    exit 1
  }
}

check_docker() {
  require_command docker "Install Docker Desktop (macOS/Windows) or Docker Engine (Linux): https://docs.docker.com/get-docker/"
  if ! docker info >/dev/null 2>&1; then
    echo "Docker is installed but not reachable. Start Docker Desktop (or the Docker Engine service), then try again." >&2
    exit 1
  fi
  if ! docker compose version >/dev/null 2>&1; then
    echo "The 'docker compose' plugin is not available. It ships with current Docker Desktop and Docker Engine installs — see https://docs.docker.com/compose/install/." >&2
    exit 1
  fi
}

run_lab() {
  provider=$1
  action=$2
  shift 2

  case "$provider" in
    aws) port=8081; project=enjyra-b01 ;;
    azure) port=8082; project=enjyra-b02 ;;
    gcp) port=8083; project=enjyra-b03 ;;
    *) usage ;;
  esac

  compose_file="$REPO_ROOT/compose/$provider.compose.yml"
  if [ ! -f "$compose_file" ]; then
    echo "Could not find $compose_file — is this a complete enjyra-cloud-labs checkout?" >&2
    exit 1
  fi

  compose() {
    (cd "$REPO_ROOT/compose" && docker compose -p "$project" -f "$compose_file" "$@")
  }

  case "$action" in
    start)
      compose up -d emulator console
      echo "ENJYRA $provider local lab is starting."
      echo "Console: http://localhost:$port"
      echo "Status:  $LAUNCHER_NAME $provider status"
      ;;
    status)
      compose ps
      ;;
    cli)
      [ "$#" -gt 0 ] || usage
      compose --profile tools run --rm cli "$@"
      ;;
    reset)
      compose exec -T console python -c "import urllib.request; request=urllib.request.Request('http://127.0.0.1:8080/api/reset', data=b'{}', headers={'Content-Type':'application/json'}, method='POST'); print(urllib.request.urlopen(request, timeout=30).read().decode())"
      echo "Only the $provider lesson resources were reset."
      ;;
    logs)
      compose logs --tail=120 emulator console
      ;;
    stop)
      compose down
      echo "ENJYRA $provider local lab stopped. Its lesson-scoped volume is preserved for the next start."
      ;;
    *) usage ;;
  esac
}

main() {
  [ "$#" -ge 2 ] || usage
  check_docker
  run_lab "$@"
}
