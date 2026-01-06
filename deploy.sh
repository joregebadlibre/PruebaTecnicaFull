#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"

SHOW_LOGS=false
DO_DOWN=false
CLEAN_VOLUMES=false

for arg in "$@"; do
  case "$arg" in
    --logs)
      SHOW_LOGS=true
      ;;
    --down)
      DO_DOWN=true
      ;;
    --clean)
      CLEAN_VOLUMES=true
      ;;
    -h|--help)
      echo "Usage: $(basename "$0") [--logs] [--down] [--clean]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $(basename "$0") [--logs] [--down] [--clean]"
      exit 1
      ;;
  esac
done

if [[ "$DO_DOWN" == "true" ]]; then
  if [[ "$CLEAN_VOLUMES" == "true" ]]; then
    docker compose -f "$COMPOSE_FILE" down -v
  else
    docker compose -f "$COMPOSE_FILE" down
  fi
  exit 0
fi

docker compose -f "$COMPOSE_FILE" build

docker compose -f "$COMPOSE_FILE" up -d

echo "\nServicios levantados:"
docker compose -f "$COMPOSE_FILE" ps

echo "\nURLs:"
echo "- API:   http://localhost:8080"
echo "- Front: http://localhost:4000"

if [[ "$SHOW_LOGS" == "true" ]]; then
  docker compose -f "$COMPOSE_FILE" logs -f
fi
