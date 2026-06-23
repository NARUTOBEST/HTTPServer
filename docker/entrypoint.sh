#!/bin/bash
set -euo pipefail

WAIT_HOST="${MYSQL_WAIT_HOST:-mysql}"
WAIT_PORT="${MYSQL_WAIT_PORT:-3306}"
MAX_ATTEMPTS="${MYSQL_WAIT_RETRIES:-60}"
SLEEP_SECONDS="${MYSQL_WAIT_INTERVAL:-2}"

echo "Waiting for MySQL at ${WAIT_HOST}:${WAIT_PORT}..."
for attempt in $(seq 1 "${MAX_ATTEMPTS}"); do
  if (echo > "/dev/tcp/${WAIT_HOST}/${WAIT_PORT}") 2>/dev/null; then
    echo "MySQL is reachable."
    exec "$@"
  fi
  echo "Attempt ${attempt}/${MAX_ATTEMPTS}: MySQL not ready, retrying in ${SLEEP_SECONDS}s..."
  sleep "${SLEEP_SECONDS}"
done

echo "MySQL is not reachable after ${MAX_ATTEMPTS} attempts."
exit 1
