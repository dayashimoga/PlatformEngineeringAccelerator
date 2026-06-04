#!/usr/bin/env bash
# =============================================================================
# reset-all.sh — Full Tear Down & Re-creation of Platform Cluster
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Initiating full system reset..."

# 1. Destroy resources
"${SCRIPT_DIR}/destroy-all.sh"

# 2. Rebuild resources
"${SCRIPT_DIR}/start-all.sh"

echo "🔄 System reset complete."
