#!/usr/bin/env bash
# =============================================================================
# start-all.sh — Spin Up Local Kubernetes Cluster & Bootstrap Accelerator
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "🐳 Verifying Docker daemon is active..."
if ! docker info &>/dev/null; then
  echo "❌ Error: Docker daemon is not running. Please start Docker."
  exit 1
fi

CLUSTER_NAME="platform-local"

if command -v kind &>/dev/null; then
  if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "☸ Local Kind cluster '${CLUSTER_NAME}' already exists, skipping creation..."
  else
    echo "☸ Creating Kind cluster '${CLUSTER_NAME}'..."
    kind create cluster --name "${CLUSTER_NAME}"
  fi
elif command -v minikube &>/dev/null; then
  echo "☸ Starting Minikube..."
  minikube start
else
  echo "⚠️  Neither kind nor minikube found in PATH. Skipping cluster creation..."
  echo "Assuming Kubeconfig points to an active cluster."
fi

echo "🚀 Bootstrapping Platform Engineering Accelerator components..."
"${SCRIPT_DIR}/bootstrap.sh"

echo "🔍 Running cluster health diagnostics..."
"${SCRIPT_DIR}/diagnostics.sh"

echo "🎉 Local platform environment is online and ready!"
