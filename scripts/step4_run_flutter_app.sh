#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

API_BASE_URL=${API_BASE_URL:-http://localhost:3000}

echo "[Step 4] Running Flutter app against API base URL: $API_BASE_URL"
echo "Hint: Use 'API_BASE_URL=https://your-api.example.com scripts/step4_run_flutter_app.sh' to point at remote servers."

cd "$MOBILE_DIR"
flutter run --dart-define=API_BASE_URL="$API_BASE_URL"

