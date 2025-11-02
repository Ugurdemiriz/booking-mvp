#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

FLAVOR=${1:-}
BUILD_TYPE=${BUILD_TYPE:-release}
KEYSTORE_PATH=${KEYSTORE_PATH:-""}
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-""}
KEY_ALIAS=${KEY_ALIAS:-""}
KEY_PASSWORD=${KEY_PASSWORD:-""}

echo "[Step 14] Building Android App Bundle (AAB) for Play Store..."

cd "$MOBILE_DIR"

# Clean previous builds
echo "[Step 14.1] Cleaning previous builds..."
flutter clean

# Get dependencies
echo "[Step 14.2] Fetching dependencies..."
flutter pub get

# Build configuration
if [[ -n "$KEYSTORE_PATH" && -n "$KEYSTORE_PASSWORD" && -n "$KEY_ALIAS" && -n "$KEY_PASSWORD" ]]; then
  echo "[Step 14.3] Using provided keystore for signing..."
  
  # Create key.properties if it doesn't exist
  KEY_PROPERTIES="$MOBILE_DIR/android/key.properties"
  cat > "$KEY_PROPERTIES" <<EOF
storeFile=$KEYSTORE_PATH
storePassword=$KEYSTORE_PASSWORD
keyAlias=$KEY_ALIAS
keyPassword=$KEY_PASSWORD
EOF
  
  echo "✓ Keystore configuration created"
else
  echo "[Step 14.3] No keystore provided. Building unsigned AAB."
  echo "Note: Play Store will sign the app automatically if you use Play App Signing."
fi

# Build AAB
echo "[Step 14.4] Building App Bundle..."
if [[ -n "$FLAVOR" ]]; then
  flutter build appbundle --$BUILD_TYPE --flavor "$FLAVOR"
  AAB_PATH="$MOBILE_DIR/build/app/outputs/bundle/${FLAVOR}Release/app-${FLAVOR}-release.aab"
else
  flutter build appbundle --$BUILD_TYPE
  AAB_PATH="$MOBILE_DIR/build/app/outputs/bundle/release/app-release.aab"
fi

if [[ -f "$AAB_PATH" ]]; then
  AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
  echo "✓ AAB built successfully: $AAB_PATH"
  echo "  Size: $AAB_SIZE"
  echo ""
  echo "Next steps:"
  echo "  1. Upload AAB to Play Console: $AAB_PATH"
  echo "  2. Run: scripts/step15_upload_to_play.sh"
else
  echo "✗ AAB build failed. Check the output above for errors." >&2
  exit 1
fi

