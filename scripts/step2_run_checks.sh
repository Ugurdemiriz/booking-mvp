#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"
SERVER_DIR="$ROOT_DIR/server"

echo "[Step 2] Running Flutter static analysis..."
(cd "$MOBILE_DIR" && flutter analyze)

echo "[Step 2] Building NestJS project to ensure TypeScript passes..."
(cd "$SERVER_DIR" && npm run build)

echo "[Step 2] Checks completed successfully."

