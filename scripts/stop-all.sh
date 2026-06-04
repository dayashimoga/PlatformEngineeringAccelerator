#!/usr/bin/env bash
# =============================================================================
# stop-all.sh — Pause or Stop Local Platform Cluster
# =============================================================================
set -euo pipefail

echo "Stopping local platform services..."

if command -v kind &>/dev/null; then
  echo "Stopping Kind nodes docker containers..."
  docker ps -q --filter "label=io.x-k8s.kind.cluster" | xargs -I {} docker stop {} || true
elif command -v minikube &>/dev/null; then
  echo "Pausing Minikube..."
  minikube pause || true
else
  echo "No local Kind or Minikube clusters detected."
fi

echo "✅ Platform services stopped successfully."
