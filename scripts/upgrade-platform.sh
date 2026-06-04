#!/usr/bin/env bash
# =============================================================================
# upgrade-platform.sh — Upgrade Platform Operator and Helm Packages
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Initiating Platform Engineering Accelerator component upgrades..."

# 1. Update upstream repositories
if command -v helm &>/dev/null; then
  echo "Updating Helm chart caches..."
  helm repo update
fi

# 2. Upgrade core controllers
echo "Re-applying setup configurations..."
"${SCRIPT_DIR}/setup-argocd.sh"
"${SCRIPT_DIR}/setup-monitoring.sh"
"${SCRIPT_DIR}/setup-otel.sh"

echo "✅ Upgrade sequence completed successfully."
