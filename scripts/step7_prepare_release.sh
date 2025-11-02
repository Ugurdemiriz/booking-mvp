#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"
SERVER_DIR="$ROOT_DIR/server"

echo "[Step 7] Preparing release artifacts..."

echo "[Step 7.1] Validating server build..."
(cd "$SERVER_DIR" && npm run build)

echo "[Step 7.2] Validating Flutter build..."
(cd "$MOBILE_DIR" && flutter pub get)
(cd "$MOBILE_DIR" && flutter analyze)

echo "[Step 7.3] Checking Android release configuration..."
if [[ ! -d "$MOBILE_DIR/android" ]]; then
  echo "Warning: Android directory not found. Run 'flutter create .' in mobile/ to initialize Android structure."
fi

echo "[Step 7] Release preparation complete."
echo ""
echo "Next steps:"
echo "  - Review version numbers in pubspec.yaml and server/package.json"
echo "  - Ensure server/.env has production-ready credentials"
echo "  - Run 'scripts/step8_build_and_sign.sh' to create signed release"

