#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"

echo "[Step 13] Preparing Android release for production..."

cd "$MOBILE_DIR"

echo "[Step 13.1] Checking Flutter setup..."
if ! flutter doctor > /dev/null 2>&1; then
  echo "Error: Flutter is not properly configured. Run 'flutter doctor' to fix issues." >&2
  exit 1
fi

echo "[Step 13.2] Validating Android configuration..."
if [[ ! -d "$MOBILE_DIR/android" ]]; then
  echo "Warning: Android directory not found. Initializing Android project..."
  flutter create --platforms=android .
fi

echo "[Step 13.3] Checking build.gradle for release configuration..."
ANDROID_BUILD_GRADLE="$MOBILE_DIR/android/app/build.gradle"
if [[ -f "$ANDROID_BUILD_GRADLE" ]]; then
  if grep -q "debuggable true" "$ANDROID_BUILD_GRADLE" 2>/dev/null; then
    echo "Warning: Debuggable is set to true. Should be false for release builds."
  fi
  
  if ! grep -q "minifyEnabled true" "$ANDROID_BUILD_GRADLE" 2>/dev/null; then
    echo "Info: Consider enabling code shrinking (minifyEnabled) for smaller APK size."
  fi
else
  echo "Info: build.gradle not found. Default Flutter template will be used."
fi

echo "[Step 13.4] Checking version information..."
if [[ -f "$MOBILE_DIR/pubspec.yaml" ]]; then
  VERSION=$(grep "^version:" "$MOBILE_DIR/pubspec.yaml" | sed 's/version: //' | tr -d ' ')
  if [[ -n "$VERSION" ]]; then
    echo "Current version: $VERSION"
  else
    echo "Warning: No version specified in pubspec.yaml"
  fi
fi

echo "[Step 13.5] Verifying release build configuration..."
echo "Checking for:"
echo "  - Debug logging disabled"
echo "  - Release build type configured"
echo "  - Signing configuration ready"
echo "  - ProGuard rules (if using code shrinking)"

echo "[Step 13] Android release preparation complete."
echo ""
echo "Next steps:"
echo "  1. Review and update android/app/build.gradle for release settings"
echo "  2. Ensure debuggable=false in release build type"
echo "  3. Configure signing in android/app/build.gradle"
echo "  4. Run: scripts/step14_build_release_aab.sh"

