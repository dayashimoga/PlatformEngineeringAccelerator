#!/usr/bin/env bash
# =============================================================================
# learn.sh — Interactive Learning CLI
# =============================================================================
set -euo pipefail

show_menu() {
  clear
  echo "================================================================="
  echo "   🎓 UNIVERSAL PLATFORM ENGINEERING MASTERY SYSTEM (UPEMS)   "
  echo "================================================================="
  echo "  1) Level 1: Beginner     — Containers & Docker"
  echo "  2) Level 2: Intermediate — Infrastructure & Kubernetes"
  echo "  3) Level 3: Advanced     — Helm & Argo CD"
  echo "  4) Level 4: Expert       — OpenTelemetry & OPA Policies"
  echo "  5) Check My Learning Path & Scores"
  echo "  6) Exit"
  echo "================================================================="
  echo -n "Select a level to view lessons (1-6): "
}

read_choice() {
  local choice
  read -r choice
  case $choice in
    1)
      clear
      echo "📖 Level 1: Beginner — Docker Concepts"
      echo "--------------------------------------"
      echo "Concepts covered: container runtimes, layered filesystems, multi-stage builds."
      echo "Read: concepts/docker/01-introduction.md"
      echo "Lab:  labs/01-docker-hardening/"
      echo ""
      echo -n "Press Enter to return to menu..."; read -r _ ;;
    2)
      clear
      echo "📖 Level 2: Intermediate — Terraform & Kubernetes"
      echo "------------------------------------------------"
      echo "Concepts covered: networking modules, pods, HPA, and services."
      echo "Read: concepts/kubernetes/01-introduction.md"
      echo "Lab:  labs/02-terraform-vpc/ & labs/03-k8s-probes/"
      echo ""
      echo -n "Press Enter to return to menu..."; read -r _ ;;
    3)
      clear
      echo "📖 Level 3: Advanced — Helm & Argo CD"
      echo "------------------------------------"
      echo "Concepts covered: Helm templates, values files, ApplicationSets."
      echo "Read: concepts/argocd/01-introduction.md"
      echo "Lab:  labs/04-argocd-gitops/"
      echo ""
      echo -n "Press Enter to return to menu..."; read -r _ ;;
    4)
      clear
      echo "📖 Level 4: Expert — OpenTelemetry & OPA"
      echo "---------------------------------------"
      echo "Concepts covered: log ingestion, trace correlation, Rego policies."
      echo "Read: concepts/opentelemetry/01-introduction.md"
      echo "Lab:  labs/05-otel-metrics/ & labs/06-security-policies/"
      echo ""
      echo -n "Press Enter to return to menu..."; read -r _ ;;
    5)
      clear
      echo "📊 Current Learning Path Status"
      echo "-------------------------------"
      cat LEARNING_PATH.md | tail -n 12
      echo ""
      echo -n "Press Enter to return to menu..."; read -r _ ;;
    6)
      exit 0 ;;
    *)
      echo "Invalid selection."
      sleep 1 ;;
  esac
}

while true; do
  show_menu
  read_choice
done
