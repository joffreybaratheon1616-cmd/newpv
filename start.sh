#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Persistent data root (Railway Volume mount or local folder).
# Set DATA_DIR in the environment to a volume path in production.
DATA_ROOT="${DATA_DIR:-./accstore_data}"
mkdir -p "$DATA_ROOT" "$DATA_ROOT/packs"
chmod 700 "$DATA_ROOT" "$DATA_ROOT/packs" 2>/dev/null || true

# Fail early if required env vars are missing (mirrors config.py validation).
missing=0
for var in API_ID API_HASH BOT_TOKEN ADMIN_IDS; do
  if [ -z "${!var:-}" ]; then
    echo "[FATAL] Required environment variable \`$var\` is missing or empty."
    missing=1
  fi
done
if [ "$missing" -ne 0 ]; then
  echo "        Set them in .env / Railway Variables before starting."
  exit 1
fi

exec python main.py
