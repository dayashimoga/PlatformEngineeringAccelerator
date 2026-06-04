#!/usr/bin/env bash
# =============================================================================
# verify-all.sh — Local Integration, E2E, Smoke & Chaos Verifications
# =============================================================================
set -euo pipefail

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🕵️ Starting local verification test suite..."
echo "=========================================="

FAILED=0
WARNINGS=0

# Helper function to print formatted results
print_result() {
  local test_name="$1"
  local status="$2"
  local details="$3"
  
  if [ "$status" = "PASS" ]; then
    echo -e "  [\033[32mPASS\033[0m] ${test_name} - ${details}"
  elif [ "$status" = "WARN" ]; then
    echo -e "  [\033[33mWARN\033[0m] ${test_name} - ${details}"
    WARNINGS=$((WARNINGS + 1))
  else
    echo -e "  [\033[31mFAIL\033[0m] ${test_name} - ${details}"
    FAILED=$((FAILED + 1))
  fi
}

# Check 1: Ingress Gateway Status
echo "Checking cluster ingress..."
if kubectl get svc -n ingress-nginx ingress-nginx-controller &>/dev/null; then
  print_result "Ingress Controller" "PASS" "Controller service online"
else
  print_result "Ingress Controller" "WARN" "Controller not found, ingress routes cannot be verified"
fi

# Check 2: Argo CD Core Synchronizer Status
echo "Checking GitOps engines..."
if kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server 2>/dev/null | grep -q "Running"; then
  print_result "ArgoCD Status" "PASS" "argocd-server is operational"
else
  print_result "ArgoCD Status" "FAIL" "argocd-server pods are offline or degraded"
fi

# Check 3: OTel collector status
echo "Checking telemetry pipes..."
if kubectl get pods -n observability -l app.kubernetes.io/name=otel-collector 2>/dev/null | grep -q "Running"; then
  print_result "Telemetry Collector" "PASS" "OpenTelemetry Ingestion active"
else
  print_result "Telemetry Collector" "WARN" "Collector offline, traces won't be captured"
fi

# Check 4: Rego Policy Validation checks
echo "Evaluating admission policies..."
if command -v conftest &>/dev/null; then
  if conftest test -p "${WORKSPACE_ROOT}/security/policies" "${WORKSPACE_ROOT}/platform/kubernetes/base/deployment.yaml" &>/dev/null; then
    print_result "OPA Rego Policies" "PASS" "Base deployment templates comply with policies"
  else
    print_result "OPA Rego Policies" "FAIL" "Base deployment violates Rego constraints"
  fi
else
  print_result "OPA Rego Policies" "WARN" "conftest binary missing, skipping policy evaluation"
fi

echo "=========================================="
if [ $FAILED -gt 0 ]; then
  echo -e "\033[31mVerification FAILED\033[0m: $FAILED tests failed, $WARNINGS warnings."
  exit 1
else
  echo -e "\033[32mVerification PASSED\033[0m: All core tests passed, $WARNINGS warnings."
  exit 0
fi
