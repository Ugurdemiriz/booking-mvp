#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT_DIR/server"

ENV_FILE="$SERVER_DIR/.env"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: '$ENV_FILE' is missing. Copy '.env.example' and provide Google OAuth credentials before starting the API." >&2
  exit 1
fi

echo "[Step 3] Starting NestJS API in watch mode..."
echo "Press Ctrl+C to stop."
cd "$SERVER_DIR"
npm run start:dev

