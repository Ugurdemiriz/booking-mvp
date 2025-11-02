#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

KEYSTORE_PATH=${KEYSTORE_PATH:-""}
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-""}
KEY_ALIAS=${KEY_ALIAS:-""}
KEY_PASSWORD=${KEY_PASSWORD:-""}

FLAVOR=${1:-}
BUILD_TYPE=${BUILD_TYPE:-release}

echo "[Step 8] Building and signing Android release..."

cd "$MOBILE_DIR"

if [[ -n "$KEYSTORE_PATH" && -n "$KEYSTORE_PASSWORD" && -n "$KEY_ALIAS" && -n "$KEY_PASSWORD" ]]; then
  echo "[Step 8] Using provided keystore for signing..."
  
  # Create key.properties if it doesn't exist
  KEY_PROPERTIES="$MOBILE_DIR/android/key.properties"
  cat > "$KEY_PROPERTIES" <<EOF
storeFile=$KEYSTORE_PATH
storePassword=$KEYSTORE_PASSWORD
keyAlias=$KEY_ALIAS
keyPassword=$KEY_PASSWORD
EOF
  
  if [[ -n "$FLAVOR" ]]; then
    flutter build apk --$BUILD_TYPE --flavor "$FLAVOR"
    flutter build appbundle --$BUILD_TYPE --flavor "$FLAVOR"
  else
    flutter build apk --$BUILD_TYPE
    flutter build appbundle --$BUILD_TYPE
  fi
  
  echo "[Step 8] Signed APK: mobile/build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
  echo "[Step 8] Signed AAB: mobile/build/app/outputs/bundle/$([ -n "$FLAVOR" ] && echo "${FLAVOR}Release" || echo "release")/app-$([ -n "$FLAVOR" ] && echo "${FLAVOR}-" || echo "")$BUILD_TYPE.aab"
else
  echo "[Step 8] No keystore provided. Building unsigned release..."
  echo "Hint: Set KEYSTORE_PATH, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD to sign automatically."
  
  if [[ -n "$FLAVOR" ]]; then
    flutter build apk --$BUILD_TYPE --flavor "$FLAVOR"
  else
    flutter build apk --$BUILD_TYPE
  fi
  
  echo "[Step 8] Unsigned APK: mobile/build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
  echo "[Step 8] Note: Sign this APK manually with apksigner or upload AAB to Play Console for automatic signing."
fi

