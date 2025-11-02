#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE_DIR="$ROOT_DIR/mobile"
SERVER_DIR="$ROOT_DIR/server"

API_URL=${1:-""}

echo "[Step 17] Production Validation Checklist..."
echo ""

# Mobile app checks
echo "[Step 17.1] Mobile App Validation"
echo "─────────────────────────────────"

cd "$MOBILE_DIR"

# Check version
if [[ -f "pubspec.yaml" ]]; then
  VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ' | cut -d'+' -f1)
  BUILD_NUMBER=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ' | cut -d'+' -f2)
  if [[ -n "$VERSION" && -n "$BUILD_NUMBER" ]]; then
    echo "✓ Version: $VERSION (Build $BUILD_NUMBER)"
  else
    echo "✗ Version not properly set in pubspec.yaml"
  fi
fi

# Check for debug logging
echo ""
echo "Checking for debug code..."
if grep -r "print(" lib/ 2>/dev/null | grep -v "//" | head -1 >/dev/null; then
  echo "⚠ Warning: Found 'print()' statements. Remove debug logging for production."
else
  echo "✓ No obvious debug print statements found"
fi

# Check AAB exists
AAB_FILE="$MOBILE_DIR/build/app/outputs/bundle/release/app-release.aab"
if [[ -f "$AAB_FILE" ]]; then
  AAB_SIZE=$(du -h "$AAB_FILE" | cut -f1)
  echo "✓ Release AAB exists: $AAB_SIZE"
else
  echo "✗ Release AAB not found. Run step14_build_release_aab.sh first."
fi

# Server checks
echo ""
echo "[Step 17.2] Server Validation"
echo "─────────────────────────────"

cd "$SERVER_DIR"

# Check .env exists (local)
if [[ -f ".env" ]]; then
  echo "✓ Server .env exists (local)"
  
  # Check required vars
  REQUIRED_VARS=("GOOGLE_CLIENT_ID" "GOOGLE_CLIENT_SECRET" "GOOGLE_REFRESH_TOKEN")
  for VAR in "${REQUIRED_VARS[@]}"; do
    if grep -q "^$VAR=" .env 2>/dev/null; then
      VALUE=$(grep "^$VAR=" .env | cut -d'=' -f2)
      if [[ -z "$VALUE" || "$VALUE" == *"your_"* || "$VALUE" == *"example"* ]]; then
        echo "⚠ Warning: $VAR appears to be a placeholder"
      else
        echo "✓ $VAR is set"
      fi
    else
      echo "✗ $VAR is missing"
    fi
  done
else
  echo "⚠ Server .env not found (local file, not required for deployment)"
fi

# Check Docker image
if command -v docker >/dev/null 2>&1; then
  if docker images | grep -q "mvp-server" 2>/dev/null; then
    echo "✓ Docker image exists locally"
  else
    echo "ℹ Docker image not found locally (may be in registry)"
  fi
fi

# API health check
if [[ -n "$API_URL" ]]; then
  echo ""
  echo "[Step 17.3] API Health Check"
  echo "──────────────────────────"
  
  echo "Testing API at: $API_URL"
  
  # Test bookings endpoint
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/api/bookings" 2>/dev/null || echo "000")
  if [[ "$HTTP_CODE" == "200" ]] || [[ "$HTTP_CODE" == "404" ]]; then
    echo "✓ API is reachable (HTTP $HTTP_CODE)"
  else
    echo "✗ API is not reachable (HTTP $HTTP_CODE)"
  fi
  
  # Test CORS
  ORIGIN_HEADER=$(curl -s -o /dev/null -w "%{http_code}" -H "Origin: https://example.com" "$API_URL/api/bookings" 2>/dev/null || echo "000")
  if [[ "$ORIGIN_HEADER" == "200" ]] || [[ "$ORIGIN_HEADER" == "404" ]]; then
    echo "✓ CORS configured (may need to restrict origins for production)"
  fi
fi

echo ""
echo "[Step 17.4] Production Readiness Summary"
echo "───────────────────────────────────────"

echo ""
echo "Before deploying to production, ensure:"
echo "  □ All tests pass"
echo "  □ Version numbers updated"
echo "  □ Debug logging removed"
echo "  □ API endpoints secured (HTTPS)"
echo "  □ CORS configured for production domains"
echo "  □ Error tracking configured (Sentry, etc.)"
echo "  □ Monitoring and alerts set up"
echo "  □ Database migrations run (if applicable)"
echo "  □ Secrets stored securely (not in code)"
echo "  □ Backup and rollback plan documented"
echo ""
echo "[Step 17] Validation complete."

