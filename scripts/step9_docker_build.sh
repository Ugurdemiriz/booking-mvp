#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT_DIR/server"

IMAGE_NAME=${IMAGE_NAME:-mvp-server}
IMAGE_TAG=${IMAGE_TAG:-latest}
REGISTRY=${REGISTRY:-""}

echo "[Step 9] Building Docker image for server..."

cd "$SERVER_DIR"

if [[ -n "$REGISTRY" ]]; then
  FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
else
  FULL_IMAGE_NAME="$IMAGE_NAME:$IMAGE_TAG"
fi

echo "[Step 9] Building image: $FULL_IMAGE_NAME"
docker build -t "$FULL_IMAGE_NAME" .

echo "[Step 9] Image built successfully."
echo "[Step 9] To test locally: docker run -p 3000:3000 --env-file .env $FULL_IMAGE_NAME"
echo "[Step 9] To push to registry: docker push $FULL_IMAGE_NAME"

