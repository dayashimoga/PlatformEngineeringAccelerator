#!/usr/bin/env bash
# =============================================================================
# mentor.sh — Interactive Mentor & Q&A Coach
# =============================================================================
set -euo pipefail

clear
echo "================================================================="
echo "   🧠 INTERACTIVE MENTOR MODE — TECHNICAL INTERVIEW COACH      "
echo "================================================================="
echo "Welcome! I am your Platform Engineering Mentor."
echo "I will ask you 3 architectural questions. Let's test your readiness!"
echo "================================================================="
echo ""

# Question 1
echo "❓ Question 1: What is the primary difference between a Liveness Probe and a Readiness Probe in Kubernetes?"
echo -n "Your Answer: "
read -r answer1
echo ""
echo "💡 Mentor Feedback:"
echo "Good! Remember: A Liveness Probe decides if a container needs to be restarted, whereas a Readiness Probe decides if the container can receive traffic."
echo "================================================================="
echo ""

# Question 2
echo "❓ Question 2: Why should you avoid using the ':latest' tag in container image configurations?"
echo -n "Your Answer: "
read -r answer2
echo ""
echo "💡 Mentor Feedback:"
echo "Exactly. Using ':latest' breaks build reproducibility, leads to tracking ambiguities, and triggers policy violations in strict OPA engines."
echo "================================================================="
echo ""

# Question 3
echo "❓ Question 3: How does GitOps (e.g. Argo CD) mitigate cluster configuration drift?"
echo -n "Your Answer: "
read -r answer3
echo ""
echo "💡 Mentor Feedback:"
echo "Spot on. Argo CD runs a continuous reconciliation loop, comparing live cluster configurations to the state defined in Git. If drift is detected, it triggers alerts or auto-heals."
echo ""
echo "================================================================="
echo "🎉 Interview Coaching Session Complete! You've done well."
echo "================================================================="
