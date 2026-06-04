#!/usr/bin/env bash
# =============================================================================
# run-simulation.sh — Chaos Outage Simulator
# =============================================================================
set -euo pipefail

show_simulations() {
  clear
  echo "================================================================="
  echo "    💥 PRODUCTION OUTAGE SIMULATION SYSTEM (CHAOS RUNNER)      "
  echo "================================================================="
  echo "  1) Simulate Pod Failure (CrashLoopBackOff)"
  echo "  2) Simulate Traffic Spike (HPA Scaling Check)"
  echo "  3) Simulate Security Breach (OPA Policy Enforcement)"
  echo "  4) Exit"
  echo "================================================================="
  echo -n "Select an incident simulation to trigger (1-4): "
}

run_simulation() {
  local choice
  read -r choice
  case $choice in
    1)
      clear
      echo "🔥 Incident Triggered: Pod Failure (CrashLoopBackOff)"
      echo "-----------------------------------------------------"
      echo "Symptoms: Workload restarts repeatedly. Exit code 137."
      echo "Tasks: Check container memory requests/limits in values.yaml."
      echo "Refer to runbook: docs/runbooks/pod-crashloop.md"
      echo ""
      echo -n "Press Enter to return to dashboard..."; read -r _ ;;
    2)
      clear
      echo "🔥 Incident Triggered: Traffic Spike"
      echo "-----------------------------------"
      echo "Symptoms: P95 Latency exceeds 2s. High throughput rates."
      echo "Tasks: Configure scaling limits inside platform/kubernetes/base/hpa.yaml."
      echo "Refer to runbook: docs/runbooks/high-latency.md"
      echo ""
      echo -n "Press Enter to return to dashboard..."; read -r _ ;;
    3)
      clear
      echo "🔥 Incident Triggered: Security Policy Breach"
      echo "--------------------------------------------"
      echo "Symptoms: Deployments blocked by admission hooks."
      echo "Tasks: Verify container securityContext settings and drop capabilities."
      echo "Refer to policy rules: security/policies/require-security-context.rego"
      echo ""
      echo -n "Press Enter to return to dashboard..."; read -r _ ;;
    4)
      exit 0 ;;
    *)
      echo "Invalid selection."
      sleep 1 ;;
  esac
}

while true; do
  show_simulations
  run_simulation
done
