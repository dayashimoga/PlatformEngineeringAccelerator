#!/usr/bin/env bash
# =============================================================================
# destroy-all.sh — Tear Down Local Cluster & Infrastructure Resources
# =============================================================================
set -euo pipefail

CLUSTER_NAME="platform-local"

echo "💥 Starting total destruction of local platform resources..."

if command -v kind &>/dev/null; then
  echo "Deleting Kind cluster '${CLUSTER_NAME}'..."
  kind delete cluster --name "${CLUSTER_NAME}" || true
elif command -v minikube &>/dev/null; then
  echo "Deleting Minikube cluster..."
  minikube delete || true
else
  echo "No local cluster tool detected. Assuming direct cleanup of namespaces..."
  kubectl delete ns dev qa uat prod argocd monitoring observability security --ignore-not-found=true || true
fi

echo "🧹 Cleaning up local directories and logs..."
find . -name "*.tfstate*" -delete
find . -name "*.tfplan" -delete
find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true

echo "💥 Destruction complete."
