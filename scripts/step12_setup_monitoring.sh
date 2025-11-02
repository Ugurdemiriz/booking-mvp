#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT_DIR/server"

echo "[Step 12] Setting up monitoring and observability..."
echo ""
echo "This script helps configure logging and error tracking."
echo ""

echo "[Step 12.1] Checking for structured logging setup..."
if grep -q "winston\|pino\|bunyan" "$SERVER_DIR/package.json" 2>/dev/null; then
  echo "✓ Logging library detected"
else
  echo "ℹ Consider adding a logging library:"
  echo "  npm install --save winston"
  echo "  or"
  echo "  npm install --save pino"
fi

echo ""
echo "[Step 12.2] Environment-specific recommendations:"
echo ""
echo "For production monitoring:"
echo "  1. Add Sentry for error tracking:"
echo "     - Mobile: https://pub.dev/packages/sentry_flutter"
echo "     - Server: https://docs.sentry.io/platforms/javascript/guides/nestjs/"
echo ""
echo "  2. Set up log aggregation:"
echo "     - CloudWatch (AWS)"
echo "     - Google Cloud Logging (GCP)"
echo "     - Datadog / New Relic"
echo ""
echo "  3. Configure health check endpoints:"
echo "     - Add GET /api/health endpoint in server"
echo "     - Monitor response times and error rates"
echo ""
echo "  4. Set up alerts:"
echo "     - API response time > 2s"
echo "     - Error rate > 5%"
echo "     - Calendar API failures"
echo ""
echo "[Step 12] Monitoring setup guide complete."

