#!/usr/bin/env bash
# =============================================================================
# setup-argocd.sh — Argo CD Installation & Configuration
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Installing Argo CD via Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install Argo CD
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --set server.service.type=ClusterIP \
  --wait

echo "Applying customized Argo CD configurations..."
kubectl apply -f "${WORKSPACE_ROOT}/platform/argocd/argocd-cm.yaml"
kubectl apply -f "${WORKSPACE_ROOT}/platform/argocd/argocd-rbac-cm.yaml"
kubectl apply -f "${WORKSPACE_ROOT}/platform/argocd/notifications-cm.yaml"

echo "Creating AppProject and bootstrap applications..."
kubectl apply -f "${WORKSPACE_ROOT}/platform/argocd/applications/project.yaml"
kubectl apply -f "${WORKSPACE_ROOT}/platform/argocd/applications/applicationset.yaml"

echo "Argo CD setup complete."
