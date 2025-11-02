#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ENVIRONMENT=${1:-prod}
API_URL=${2:-""}

echo "[Step 19] Production Deployment - $ENVIRONMENT"
echo "═══════════════════════════════════════════════════"
echo ""

# Pre-deployment checks
echo "[Step 19.1] Pre-Deployment Validation"
echo "───────────────────────────────────"

# Run validation
if [[ -n "$API_URL" ]]; then
  "$ROOT_DIR/scripts/step17_production_validation.sh" "$API_URL"
else
  "$ROOT_DIR/scripts/step17_production_validation.sh"
fi

echo ""
read -p "Continue with deployment to $ENVIRONMENT? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Deployment cancelled."
  exit 0
fi

# Deploy server
echo ""
echo "[Step 19.2] Deploying Server"
echo "───────────────────────────"

if command -v gh >/dev/null 2>&1; then
  echo "Triggering GitHub Actions deployment..."
  "$ROOT_DIR/scripts/step6_trigger_server_deploy.sh" "$ENVIRONMENT"
  echo "✓ Deployment workflow triggered"
  echo ""
  echo "Monitor progress at: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/actions"
else
  echo "GitHub CLI not found. Manual deployment required:"
  echo "  1. Go to GitHub Actions"
  echo "  2. Run 'server-deploy' workflow"
  echo "  3. Select environment: $ENVIRONMENT"
fi

# Mobile app deployment
echo ""
echo "[Step 19.3] Mobile App Deployment"
echo "────────────────────────────────"

echo "Mobile app deployment steps:"
echo ""
echo "1. Build release AAB:"
echo "   scripts/step14_build_release_aab.sh"
echo ""
echo "2. Upload to Play Store:"
echo "   scripts/step15_upload_to_play.sh production"
echo ""
echo "3. Configure Play App Signing (if first time):"
echo "   scripts/step16_setup_play_signing.sh"
echo ""

read -p "Have you already built and uploaded the mobile app? (yes/no): " MOBILE_DONE
if [[ "$MOBILE_DONE" != "yes" ]]; then
  echo ""
  echo "Before completing mobile deployment:"
  echo "  □ Build release AAB"
  echo "  □ Upload to Play Console"
  echo "  □ Complete store listing"
  echo "  □ Submit for review (if needed)"
  echo "  □ Roll out to production track"
fi

# Post-deployment
echo ""
echo "[Step 19.4] Post-Deployment"
echo "─────────────────────────"

echo "After deployment, perform these checks:"
echo ""
echo "Server:"
echo "  □ API health endpoint responds"
echo "  □ Bookings endpoint works"
echo "  □ Calendar integration works"
echo "  □ Error logs monitored"
echo ""
echo "Mobile:"
echo "  □ App available in Play Store"
echo "  □ App installs correctly"
echo "  □ All features work"
echo "  □ No crashes reported"
echo ""
echo "Monitoring:"
echo "  □ Error tracking alerts configured"
echo "  □ Performance metrics monitored"
echo "  □ User feedback reviewed"
echo ""

if [[ -n "$API_URL" ]]; then
  echo "[Step 19.5] Validating Deployment"
  echo "─────────────────────────────────"
  "$ROOT_DIR/scripts/step11_validate_deployment.sh" "$API_URL"
fi

echo ""
echo "[Step 19] Production deployment initiated for $ENVIRONMENT"
echo ""
echo "Next steps:"
echo "  1. Monitor deployment progress"
echo "  2. Validate all endpoints"
echo "  3. Test mobile app thoroughly"
echo "  4. Monitor error logs"
echo "  5. Gather user feedback"

