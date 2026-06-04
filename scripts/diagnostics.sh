#!/usr/bin/env bash
# =============================================================================
# diagnostics.sh — Run Cluster Diagnostics & Status Reporting
# =============================================================================
set -euo pipefail

echo "🔍 Running Platform Engineering Accelerator Diagnostics..."
echo "========================================================="

if ! command -v kubectl &>/dev/null; then
  echo "❌ Error: kubectl CLI not found in PATH."
  exit 1
fi

echo "1. Checking active namespaces:"
kubectl get namespaces

echo -e "\n2. Checking Argo CD system health:"
kubectl get pods -n argocd || echo "  ⚠️  Argo CD namespace or pods missing."

echo -e "\n3. Checking OpenTelemetry components:"
kubectl get pods -n observability || echo "  ⚠️  Observability namespace or pods missing."

echo -e "\n4. Checking Monitoring stack:"
kubectl get pods -n monitoring || echo "  ⚠️  Monitoring namespace or pods missing."

echo -e "\n5. Checking cluster events (errors only):"
kubectl get events --all-namespaces --field-selector type=Warning --sort-by='.metadata.creationTimestamp' | tail -n 10 || true

echo -e "\n========================================================="
echo "✅ Diagnostics run complete."
