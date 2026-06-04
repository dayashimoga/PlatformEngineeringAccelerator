#!/usr/bin/env bash
# =============================================================================
# validate-all.sh — Local Validation Suite
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "🕵️ Running local validation checks..."

# 1. YAML Lint
if command -v yamllint &> /dev/null; then
  echo "🔍 Linting YAML files..."
  yamllint "${WORKSPACE_ROOT}"
else
  echo "⚠️  yamllint not installed, skipping..."
fi

# 2. Terraform validate
if command -v terraform &> /dev/null; then
  echo "🔍 Validating Terraform modules..."
  cd "${WORKSPACE_ROOT}/platform/terraform"
  terraform init -backend=false
  terraform fmt -check
  terraform validate
  cd - > /dev/null
else
  echo "⚠️  terraform CLI not installed, skipping..."
fi

# 3. Helm lint
if command -v helm &> /dev/null; then
  echo "🔍 Linting Helm chart..."
  helm lint "${WORKSPACE_ROOT}/platform/kubernetes/helm"
else
  echo "⚠️  helm CLI not installed, skipping..."
fi

# 4. OPA Conftest
if command -v conftest &> /dev/null; then
  echo "🔍 Evaluating OPA Policies against Helm templates..."
  if command -v helm &> /dev/null; then
    mkdir -p /tmp/rendered-templates
    helm template test-release "${WORKSPACE_ROOT}/platform/kubernetes/helm" > /tmp/rendered-templates/all.yaml
    conftest test -p "${WORKSPACE_ROOT}/security/policies" /tmp/rendered-templates/all.yaml
    rm -rf /tmp/rendered-templates
  fi
else
  echo "⚠️  conftest CLI not installed, skipping OPA validation..."
fi

echo "✅ All local validations passed!"
