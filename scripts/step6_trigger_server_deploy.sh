#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI ('gh') is required to trigger the deploy workflow." >&2
  exit 1
fi

ENVIRONMENT=${1:-dev}
IMAGE_TAG=${2:-}

echo "[Step 6] Triggering server-deploy workflow for environment '$ENVIRONMENT'..."

if [[ -n "$IMAGE_TAG" ]]; then
  gh workflow run server-deploy.yml \
    --field environment="$ENVIRONMENT" \
    --field image_tag="$IMAGE_TAG"
else
  gh workflow run server-deploy.yml \
    --field environment="$ENVIRONMENT"
fi

echo "[Step 6] Workflow dispatched. Track progress in the GitHub Actions UI." 

