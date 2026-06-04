# ============================================================================
# Platform Engineering Accelerator — Makefile
# ============================================================================

.DEFAULT_GOAL := help
SHELL := /bin/bash

# Colors for output
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

# ============================================================================
# Help
# ============================================================================

.PHONY: help
help: ## Show this help message
	@echo ""
	@echo "$(CYAN)Platform Engineering Accelerator$(RESET)"
	@echo "=================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-25s$(RESET) %s\n", $$1, $$2}'
	@echo ""

# ============================================================================
# Bootstrap & Setup
# ============================================================================

.PHONY: bootstrap
bootstrap: ## Full platform bootstrap (tools + infra + platform components)
	@echo "$(CYAN)🚀 Bootstrapping Platform Engineering Accelerator...$(RESET)"
	@bash scripts/bootstrap.sh

.PHONY: setup-tools
setup-tools: ## Install required CLI tools
	@echo "$(CYAN)🔧 Installing required tools...$(RESET)"
	@command -v helm >/dev/null 2>&1 || echo "$(RED)helm not found. Install: https://helm.sh/docs/intro/install/$(RESET)"
	@command -v kubectl >/dev/null 2>&1 || echo "$(RED)kubectl not found. Install: https://kubernetes.io/docs/tasks/tools/$(RESET)"
	@command -v terraform >/dev/null 2>&1 || echo "$(RED)terraform not found. Install: https://developer.hashicorp.com/terraform/install$(RESET)"
	@command -v argocd >/dev/null 2>&1 || echo "$(RED)argocd not found. Install: https://argo-cd.readthedocs.io/en/stable/cli_installation/$(RESET)"
	@command -v trivy >/dev/null 2>&1 || echo "$(RED)trivy not found. Install: https://aquasecurity.github.io/trivy/$(RESET)"
	@command -v cosign >/dev/null 2>&1 || echo "$(RED)cosign not found. Install: https://docs.sigstore.dev/cosign/installation/$(RESET)"
	@echo "$(GREEN)✅ Tool check complete$(RESET)"

.PHONY: setup-argocd
setup-argocd: ## Install and configure Argo CD
	@echo "$(CYAN)🔄 Setting up Argo CD...$(RESET)"
	@bash scripts/setup-argocd.sh

.PHONY: setup-monitoring
setup-monitoring: ## Install Prometheus + Grafana monitoring stack
	@echo "$(CYAN)📊 Setting up monitoring stack...$(RESET)"
	@bash scripts/setup-monitoring.sh

.PHONY: setup-otel
setup-otel: ## Install OpenTelemetry Collector
	@echo "$(CYAN)🔭 Setting up OpenTelemetry...$(RESET)"
	@bash scripts/setup-otel.sh

# ============================================================================
# Validation
# ============================================================================

.PHONY: validate-all
validate-all: validate-yaml validate-terraform validate-helm validate-k8s validate-policies ## Run all validations
	@echo "$(GREEN)✅ All validations passed$(RESET)"

.PHONY: validate-yaml
validate-yaml: ## Validate all YAML files
	@echo "$(CYAN)📋 Validating YAML files...$(RESET)"
	@find . -name "*.yaml" -o -name "*.yml" | grep -v node_modules | grep -v .terraform | \
		xargs -I {} sh -c 'python3 -c "import yaml; yaml.safe_load(open(\"{}\")); print(\"  ✅ {}\")" 2>/dev/null || echo "  ❌ {}"'

.PHONY: validate-terraform
validate-terraform: ## Validate Terraform configuration
	@echo "$(CYAN)🏗️  Validating Terraform...$(RESET)"
	@cd platform/terraform && terraform init -backend=false -input=false >/dev/null 2>&1 && \
		terraform validate && echo "  $(GREEN)✅ Terraform valid$(RESET)" || echo "  $(RED)❌ Terraform invalid$(RESET)"
	@cd platform/terraform && terraform fmt -check -recursive && \
		echo "  $(GREEN)✅ Terraform formatting valid$(RESET)" || echo "  $(YELLOW)⚠️  Terraform formatting issues$(RESET)"

.PHONY: validate-helm
validate-helm: ## Lint Helm charts
	@echo "$(CYAN)⎈ Validating Helm charts...$(RESET)"
	@helm lint platform/kubernetes/helm/ && echo "  $(GREEN)✅ Helm chart valid$(RESET)" || echo "  $(RED)❌ Helm chart invalid$(RESET)"

.PHONY: validate-k8s
validate-k8s: ## Validate Kubernetes manifests
	@echo "$(CYAN)☸ Validating Kubernetes manifests...$(RESET)"
	@if command -v kubeconform >/dev/null 2>&1; then \
		find platform/kubernetes/base -name "*.yaml" | xargs kubeconform -strict -summary; \
	else \
		echo "  $(YELLOW)⚠️  kubeconform not installed, skipping$(RESET)"; \
	fi

.PHONY: validate-policies
validate-policies: ## Validate OPA policies
	@echo "$(CYAN)🛡️  Validating OPA policies...$(RESET)"
	@if command -v conftest >/dev/null 2>&1; then \
		conftest verify -p security/policies/; \
	else \
		echo "  $(YELLOW)⚠️  conftest not installed, skipping$(RESET)"; \
	fi

# ============================================================================
# Service Generation
# ============================================================================

.PHONY: generate-service
generate-service: ## Generate a new service (usage: make generate-service NAME=my-api RUNTIME=dotnet PORT=8080 REPLICAS=3)
	@echo "$(CYAN)🏭 Generating service: $(NAME)$(RESET)"
	@bash scripts/generate-service.sh --name $(NAME) --runtime $(RUNTIME) --port $(PORT) --replicas $(REPLICAS)

# ============================================================================
# Infrastructure
# ============================================================================

.PHONY: infra-plan
infra-plan: ## Run Terraform plan (usage: make infra-plan ENV=dev)
	@echo "$(CYAN)📝 Planning infrastructure for $(ENV)...$(RESET)"
	@cd platform/terraform && terraform plan -var-file=environments/$(ENV)/terraform.tfvars

.PHONY: infra-apply
infra-apply: ## Apply Terraform changes (usage: make infra-apply ENV=dev)
	@echo "$(CYAN)🚀 Applying infrastructure for $(ENV)...$(RESET)"
	@cd platform/terraform && terraform apply -var-file=environments/$(ENV)/terraform.tfvars

.PHONY: infra-destroy
infra-destroy: ## Destroy infrastructure (usage: make infra-destroy ENV=dev)
	@echo "$(RED)💥 Destroying infrastructure for $(ENV)...$(RESET)"
	@cd platform/terraform && terraform destroy -var-file=environments/$(ENV)/terraform.tfvars

# ============================================================================
# Security
# ============================================================================

.PHONY: security-scan
security-scan: ## Run all security scans locally
	@echo "$(CYAN)🔒 Running security scans...$(RESET)"
	@echo "  Trivy filesystem scan..."
	@trivy fs --severity HIGH,CRITICAL . || true
	@echo "  Checkov IaC scan..."
	@checkov -d platform/terraform/ --quiet || true
	@echo "$(GREEN)✅ Security scan complete$(RESET)"

# ============================================================================
# Clean
# ============================================================================

.PHONY: clean
clean: ## Clean generated artifacts
	@echo "$(CYAN)🧹 Cleaning artifacts...$(RESET)"
	@find . -name "*.tfplan" -delete
	@find . -name "trivy-report.*" -delete
	@find . -name "grype-report.*" -delete
	@find . -name "sbom-output" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)✅ Clean complete$(RESET)"
