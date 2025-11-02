#!/usr/bin/env bash
set -euo pipefail

KEYSTORE_NAME=${1:-upload-keystore.jks}
KEY_ALIAS=${2:-upload}

echo "[Generate Keystore] Creating Android signing keystore..."
echo ""
echo "You will be prompted to enter a password for the keystore and key."
echo "Keep these passwords secure - you'll need them for signing releases."
echo ""

if [[ -f "$KEYSTORE_NAME" ]]; then
  echo "Error: Keystore file '$KEYSTORE_NAME' already exists." >&2
  exit 1
fi

keytool -genkey -v \
  -keystore "$KEYSTORE_NAME" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

echo ""
echo "[Generate Keystore] Keystore created: $KEYSTORE_NAME"
echo ""
echo "Next steps:"
echo "  1. Store this keystore securely (never commit to git)"
echo "  2. Backup the keystore and passwords"
echo "  3. Set environment variables for signing:"
echo "     export KEYSTORE_PATH=\$(pwd)/$KEYSTORE_NAME"
echo "     export KEYSTORE_PASSWORD=your_store_password"
echo "     export KEY_ALIAS=$KEY_ALIAS"
echo "     export KEY_PASSWORD=your_key_password"
echo "  4. Run: scripts/step8_build_and_sign.sh"

