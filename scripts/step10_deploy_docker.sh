#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-dev}
IMAGE_NAME=${IMAGE_NAME:-mvp-server}
IMAGE_TAG=${2:-latest}
REGISTRY=${REGISTRY:-""}

if [[ -z "$REGISTRY" ]]; then
  echo "Error: REGISTRY environment variable must be set (e.g., ghcr.io/username/repo or docker.io/username)" >&2
  exit 1
fi

FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

echo "[Step 10] Deploying Docker image to $ENVIRONMENT..."
echo "[Step 10] Image: $FULL_IMAGE_NAME"

echo "[Step 10] Deployment platform examples:"
echo ""
echo "Fly.io:"
echo "  flyctl deploy --image $FULL_IMAGE_NAME --app mvp-server-$ENVIRONMENT"
echo ""
echo "Render:"
echo "  render deploy --service mvp-server-$ENVIRONMENT"
echo ""
echo "Cloud Run:"
echo "  gcloud run deploy mvp-server-$ENVIRONMENT --image $FULL_IMAGE_NAME --region us-central1"
echo ""
echo "Kubernetes:"
echo "  kubectl set image deployment/mvp-server-$ENVIRONMENT api=$FULL_IMAGE_NAME"
echo ""
echo "Custom platform: Update this script with your deployment command."

