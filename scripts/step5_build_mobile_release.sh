#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

FLAVOR=${1:-}

echo "[Step 5] Building Flutter Android APK (unsigned)"
cd "$MOBILE_DIR"

if [[ -n "$FLAVOR" ]]; then
  flutter build apk --release --flavor "$FLAVOR"
else
  flutter build apk --release
fi

echo "[Step 5] Output located at 'mobile/build/app/outputs/flutter-apk/'."

