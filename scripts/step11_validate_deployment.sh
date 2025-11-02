#!/usr/bin/env bash
set -euo pipefail

API_URL=${1:-http://localhost:3000}

echo "[Step 11] Validating deployment at $API_URL..."

echo "[Step 11.1] Checking health endpoint..."
HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/api/bookings" || echo "000")

if [[ "$HEALTH_RESPONSE" == "200" ]] || [[ "$HEALTH_RESPONSE" == "404" ]]; then
  echo "✓ API is reachable (HTTP $HEALTH_RESPONSE)"
else
  echo "✗ API is not reachable (HTTP $HEALTH_RESPONSE)"
  exit 1
fi

echo "[Step 11.2] Testing bookings endpoint..."
BOOKINGS_RESPONSE=$(curl -s "$API_URL/api/bookings")
if echo "$BOOKINGS_RESPONSE" | grep -q "\[\]" || echo "$BOOKINGS_RESPONSE" | grep -q "id"; then
  echo "✓ Bookings endpoint responds correctly"
else
  echo "✗ Bookings endpoint returned unexpected response"
  echo "Response: $BOOKINGS_RESPONSE"
  exit 1
fi

echo "[Step 11] Deployment validation complete."
echo ""
echo "Manual checks:"
echo "  - Test calendar event creation via Flutter app"
echo "  - Verify Google Meet links are generated"
echo "  - Check error logs for any issues"

