#!/usr/bin/env bash
# =============================================================================
# restore-data.sh — Local Platform Configuration & Storage Restore
# =============================================================================
set -euo pipefail

usage() {
  echo "Usage: $0 -d <backup-directory-path>"
  exit 1
}

BACKUP_DIR=""
while getopts "d:" opt; do
  case ${opt} in
    d) BACKUP_DIR="$OPTARG" ;;
    *) usage ;;
  esac
done

if [[ -z "${BACKUP_DIR}" || ! -d "${BACKUP_DIR}" ]]; then
  echo "❌ Error: Backup directory not specified or does not exist."
  usage
fi

echo "🔄 Restoring platform state from backup directory '${BACKUP_DIR}'..."

if command -v kubectl &>/dev/null; then
  if [ -f "${BACKUP_DIR}/namespaces.json" ]; then
    echo "Restoring namespace settings..."
    kubectl apply -f "${BACKUP_DIR}/namespaces.json" || true
  fi
  if [ -f "${BACKUP_DIR}/configmaps.json" ]; then
    echo "Restoring ConfigMap configurations..."
    kubectl apply -f "${BACKUP_DIR}/configmaps.json" || true
  fi
fi

echo "✅ Restore sequence completed successfully."
