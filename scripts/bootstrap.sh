#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — Master Cluster Bootstrapper
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "🚀 Starting Platform Engineering Accelerator cluster bootstrap..."

# 1. Create namespaces
echo "📁 Creating standard system namespaces..."
kubectl apply -f "${WORKSPACE_ROOT}/platform/kubernetes/base/namespace.yaml"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace security --dry-run=client -o yaml | kubectl apply -f -

# 2. Setup Security Policies
echo "🛡️ Installing security scanner configs and policies..."
kubectl apply -f "${WORKSPACE_ROOT}/security/scanning/scanner-configs.yaml"

# 3. Setup Argo CD
echo "🔄 Setting up Argo CD..."
"${SCRIPT_DIR}/setup-argocd.sh"

# 4. Setup Monitoring & Observability
echo "📊 Setting up Prometheus, Grafana, and Alerts..."
"${SCRIPT_DIR}/setup-monitoring.sh"

# 5. Setup OpenTelemetry
echo "🔭 Setting up OpenTelemetry Collector and Auto-Instrumentation..."
"${SCRIPT_DIR}/setup-otel.sh"

echo "✅ Cluster bootstrap completed successfully! All platform services are online."
