#!/usr/bin/env bash
# =============================================================================
# setup-otel.sh — OpenTelemetry Setup
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Installing cert-manager (prerequisite for OpenTelemetry Operator)..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
kubectl wait --for=condition=Available deployment/cert-manager-webhook --namespace cert-manager --timeout=300s

echo "Installing OpenTelemetry Operator..."
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.92.0/opentelemetry-operator.yaml
kubectl wait --for=condition=Available deployment/opentelemetry-operator --namespace observability --timeout=300s

echo "Applying Otel Collector ConfigMap, deployment and services..."
kubectl create configmap otel-collector-config \
  --namespace observability \
  --from-file="${WORKSPACE_ROOT}/observability/otel/otel-collector-config.yaml" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f "${WORKSPACE_ROOT}/observability/otel/otel-collector-deployment.yaml"

echo "Applying Auto-Instrumentation resources..."
kubectl apply -f "${WORKSPACE_ROOT}/observability/otel/collectors/auto-instrumentation.yaml"

echo "OpenTelemetry setup complete."
