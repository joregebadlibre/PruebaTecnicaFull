#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"

CLEAN_VOLUMES=false

for arg in "$@"; do
  case "$arg" in
    -v|--volumes|--clean)
      CLEAN_VOLUMES=true
      ;;
    -h|--help)
      echo "Usage: $(basename "$0") [--clean|--volumes|-v]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $(basename "$0") [--clean|--volumes|-v]"
      exit 1
      ;;
  esac
done

if [[ "$CLEAN_VOLUMES" == "true" ]]; then
  docker compose -f "$COMPOSE_FILE" down -v
else
  docker compose -f "$COMPOSE_FILE" down
fi
