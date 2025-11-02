#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"
SERVER_DIR="$ROOT_DIR/server"

echo "[Step 1] Verifying prerequisites..."
for cmd in flutter dart npm node; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is not available on PATH. Please install it before continuing." >&2
    exit 1
  fi
done

echo "[Step 1] Fetching Flutter dependencies..."
flutter --version
(cd "$MOBILE_DIR" && flutter pub get)

echo "[Step 1] Installing server dependencies..."
node --version
npm --version
(cd "$SERVER_DIR" && npm install)

echo "[Step 1] Setup complete. Create '$SERVER_DIR/.env' from '.env.example' before running the API."

