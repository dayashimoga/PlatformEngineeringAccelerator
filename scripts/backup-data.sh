#!/usr/bin/env bash
# =============================================================================
# backup-data.sh — Local Platform Configuration & Storage Backup
# =============================================================================
set -euo pipefail

BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "${BACKUP_DIR}"

echo "📦 Creating platform backup in '${BACKUP_DIR}'..."

# 1. Export active K8s configurations
if command -v kubectl &>/dev/null; then
  echo "Backing up namespace configurations..."
  kubectl get ns -o json > "${BACKUP_DIR}/namespaces.json" || true
  kubectl get configmaps --all-namespaces -o json > "${BACKUP_DIR}/configmaps.json" || true
  kubectl get secrets --all-namespaces -o json > "${BACKUP_DIR}/secrets.json" || true
fi

# 2. Export local Helm repository configurations
if command -v helm &>/dev/null; then
  echo "Backing up Helm release list..."
  helm list -A -o json > "${BACKUP_DIR}/helm-releases.json" || true
fi

echo "✅ Backup completed successfully. Archive stored in: ${BACKUP_DIR}"
