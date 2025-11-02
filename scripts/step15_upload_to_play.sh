#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

TRACK=${1:-internal}  # internal, alpha, beta, production
FLAVOR=${2:-}
AAB_FILE=${AAB_FILE:-""}

echo "[Step 15] Uploading to Google Play Store..."

cd "$MOBILE_DIR"

# Find AAB file if not provided
if [[ -z "$AAB_FILE" ]]; then
  if [[ -n "$FLAVOR" ]]; then
    AAB_FILE="$MOBILE_DIR/build/app/outputs/bundle/${FLAVOR}Release/app-${FLAVOR}-release.aab"
  else
    AAB_FILE="$MOBILE_DIR/build/app/outputs/bundle/release/app-release.aab"
  fi
fi

if [[ ! -f "$AAB_FILE" ]]; then
  echo "Error: AAB file not found at $AAB_FILE" >&2
  echo "Run 'scripts/step14_build_release_aab.sh' first." >&2
  exit 1
fi

echo "[Step 15.1] AAB file found: $AAB_FILE"

# Check for Google Play Console API
if ! command -v fastlane >/dev/null 2>&1 && ! command -v bundletool >/dev/null 2>&1; then
  echo "[Step 15.2] Google Play Console API tools not found."
  echo ""
  echo "To upload to Play Store, you have several options:"
  echo ""
  echo "Option 1: Use Play Console web UI"
  echo "  1. Go to https://play.google.com/console"
  echo "  2. Select your app"
  echo "  3. Navigate to Release → Testing → $TRACK"
  echo "  4. Click 'Create new release'"
  echo "  5. Upload: $AAB_FILE"
  echo ""
  echo "Option 2: Use fastlane (recommended)"
  echo "  1. Install fastlane: gem install fastlane"
  echo "  2. Setup fastlane in mobile directory"
  echo "  3. Configure Google Play API credentials"
  echo "  4. Run: fastlane android deploy"
  echo ""
  echo "Option 3: Use Google Play Console API"
  echo "  1. Enable Google Play Android Developer API"
  echo "  2. Create service account"
  echo "  3. Grant access in Play Console"
  echo "  4. Use gcloud or API client to upload"
  echo ""
  echo "Current AAB ready for upload: $AAB_FILE"
  
  exit 0
fi

# If fastlane is available
if command -v fastlane >/dev/null 2>&1; then
  echo "[Step 15.2] Using fastlane to upload..."
  
  if [[ ! -f "$MOBILE_DIR/fastlane/Fastfile" ]]; then
    echo "Fastlane not configured. Setting up..."
    cd "$MOBILE_DIR"
    fastlane init
  fi
  
  # Upload using fastlane
  cd "$MOBILE_DIR"
  fastlane android deploy track:"$TRACK" aab:"$AAB_FILE"
  
  echo "✓ Upload complete. Check Play Console for status."
else
  echo "[Step 15.2] Manual upload required. See instructions above."
fi

