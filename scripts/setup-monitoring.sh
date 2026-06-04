#!/usr/bin/env bash
# =============================================================================
# setup-monitoring.sh — Prometheus & Grafana Setup
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Adding prometheus-community helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Installing kube-prometheus-stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues=false \
  --wait

echo "Configuring Platform alerts and recording rules..."
kubectl apply -f "${WORKSPACE_ROOT}/monitoring/alerts/platform-alerts.yaml"
kubectl apply -f "${WORKSPACE_ROOT}/monitoring/alerts/alertmanager-config.yaml"
kubectl apply -f "${WORKSPACE_ROOT}/monitoring/prometheus/prometheus-rules.yaml"

echo "Provisioning Grafana dashboards and datasources..."
kubectl apply -f "${WORKSPACE_ROOT}/monitoring/grafana/provisioning/datasources.yaml"
kubectl apply -f "${WORKSPACE_ROOT}/monitoring/grafana/provisioning/dashboards.yaml"

# Load the dashboard JSON configurations into configmaps so Grafana sidecar imports them
kubectl create configmap platform-dashboards \
  --namespace monitoring \
  --from-file="${WORKSPACE_ROOT}/monitoring/grafana/dashboards/" \
  --dry-run=client -o yaml | kubectl apply -f -

# Label the configmap so Grafana dashboard sidecar detects it
kubectl label configmap platform-dashboards \
  --namespace monitoring \
  grafana_dashboard=1 --overwrite

echo "Monitoring stack setup complete."
