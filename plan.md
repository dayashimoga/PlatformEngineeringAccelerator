# Platform Engineering Accelerator — Implementation Plan

## Overview

Build a production-grade, cloud-agnostic Platform Engineering Accelerator repository at `h:\devopsprod4jun26` that provides zero-touch CI/CD, GitOps deployments, automated security, observability, and self-service developer onboarding via Backstage.

The repository serves as a reusable blueprint — clone it, provide minimal inputs (`serviceName`, `runtime`, `port`, `replicaCount`), and get a fully operational service with CI/CD, monitoring, tracing, and security baked in.

---

## User Review Required

> [!IMPORTANT]
> **Target directory**: `h:\devopsprod4jun26` — all files will be created here. Confirm this is correct.

> [!IMPORTANT]
> **Cloud provider priority**: The plan supports AKS, EKS, and GKE equally. If you have a preferred primary cloud, I can prioritize that provider's Terraform modules and testing. Otherwise, all three get equal treatment.

> [!WARNING]
> **Estimated scope**: ~200+ files across 12 major components. This is a large generation task. I will execute in phases and validate between each phase. The full generation may take significant time.

---

## Open Questions

1. **Container Registry default**: Should GHCR be the default registry, with ACR/ECR/GCR as configurable alternatives? Or should the default be cloud-specific?
2. **Backstage instance**: Should the Backstage configuration assume a standalone Backstage instance, or should it include a full Backstage app setup (with `app-config.yaml`, plugins, etc.)?
3. **Notification channels**: For alerting (Slack, Teams, Email) — should I generate configuration stubs for all three, or focus on one?
4. **Helm repository**: Should charts be published to a Helm repository (e.g., GitHub Pages-based), or only stored in-repo?
5. **GitOps repository model**: Should the GitOps manifests live in the same repo (monorepo) or assume a separate GitOps repo that gets updated by CI?

---

## Proposed Changes

The implementation is organized into **8 phases**, ordered by dependency (foundations first).

---

### Phase 1: Repository Foundation & Governance

Sets up the repository skeleton, governance files, and developer documentation structure.

#### [NEW] Root configuration files
- `README.md` — Project overview, architecture diagram, quickstart
- `LICENSE` — MIT license
- `CODEOWNERS` — Ownership rules for platform, security, and app teams
- `.gitignore` — Comprehensive ignore for Terraform, Node, Python, .NET, Go, Java
- `.editorconfig` — Consistent formatting across IDEs
- `CONTRIBUTING.md` — Contribution guidelines
- `SECURITY.md` — Security policy and vulnerability reporting
- `Makefile` — Top-level automation commands

#### [NEW] Branch protection template
- `docs/governance/branch-protection.md` — Instructions for configuring branch protection rules, required reviews, signed commits, and release approval gates

---

### Phase 2: GitHub Actions Reusable Workflows

9 reusable workflows following the `workflow_call` pattern — no duplicated logic.

#### [NEW] [01-validate.yml](file:///h:/devopsprod4jun26/.github/workflows/01-validate.yml)
- Linting (language-agnostic via matrix)
- Formatting validation
- Helm lint (`helm lint`)
- Kubernetes manifest validation (`kubeval`/`kubeconform`)
- Terraform `fmt -check` and `validate`
- Policy validation (OPA/Conftest)
- Inputs: `working-directory`, `runtime`, `helm-chart-path`, `terraform-dir`

#### [NEW] [02-security.yml](file:///h:/devopsprod4jun26/.github/workflows/02-security.yml)
- CodeQL analysis (auto-detect language)
- Trivy filesystem scan
- Checkov IaC scan
- Dependency scanning (Grype)
- Secret scanning validation
- SBOM generation (Syft)
- Uploads all reports as workflow artifacts
- Fails on CRITICAL/HIGH vulnerabilities

#### [NEW] [03-build.yml](file:///h:/devopsprod4jun26/.github/workflows/03-build.yml)
- Matrix build for .NET, Node, Python, Java, Go
- Caches dependencies per runtime
- Outputs build artifacts

#### [NEW] [04-test.yml](file:///h:/devopsprod4jun26/.github/workflows/04-test.yml)
- Unit tests per runtime
- Coverage report generation
- Test result publishing
- Fail-fast on test failures

#### [NEW] [05-containerize.yml](file:///h:/devopsprod4jun26/.github/workflows/05-containerize.yml)
- Multi-stage Docker build
- OCI-compliant images
- SBOM generation (Syft attached to image)
- Image signing (Cosign)
- Tagging: `semantic-version`, `git-sha`, `latest`
- Inputs: `registry` (GHCR/ACR/ECR/GCR), `image-name`, `dockerfile-path`

#### [NEW] [06-publish.yml](file:///h:/devopsprod4jun26/.github/workflows/06-publish.yml)
- Push to configured registry
- Immutable tag enforcement
- Vulnerability gate (Trivy scan post-build)
- Sign and verify image attestation

#### [NEW] [07-gitops-update.yml](file:///h:/devopsprod4jun26/.github/workflows/07-gitops-update.yml)
- Update Helm values or Kustomize overlays with new image tag
- Commit to GitOps branch/repo
- Create PR for production changes
- Auto-merge for non-prod environments

#### [NEW] [08-release.yml](file:///h:/devopsprod4jun26/.github/workflows/08-release.yml)
- Semantic versioning via conventional commits
- Changelog generation
- GitHub Release creation
- Asset attachment (SBOM, security reports)

#### [NEW] [09-backstage-sync.yml](file:///h:/devopsprod4jun26/.github/workflows/09-backstage-sync.yml)
- Sync service catalog entries to Backstage
- Update component metadata
- Register/update entities in Backstage catalog

#### [NEW] Composite actions (`.github/actions/`)
- `setup-tools/action.yml` — Install shared tooling (Helm, kubectl, Terraform, Trivy, etc.)
- `docker-build/action.yml` — Reusable Docker build+push logic
- `security-scan/action.yml` — Reusable security scanning composite

#### [NEW] Caller workflow
- `ci-cd.yml` — Main orchestrator that calls all 9 reusable workflows in sequence with proper dependency chaining

---

### Phase 3: Terraform Infrastructure

Cloud-agnostic Terraform modules supporting AKS, EKS, and GKE.

#### [NEW] Module: `platform/terraform/modules/networking/`
- VPC/VNet creation
- Subnets (public, private, data)
- NAT Gateway
- Network Security Groups / Security Groups
- Variables for CIDR ranges, cloud provider selection

#### [NEW] Module: `platform/terraform/modules/kubernetes/`
- AKS cluster (`azurerm_kubernetes_cluster`)
- EKS cluster (`aws_eks_cluster` + `aws_eks_node_group`)
- GKE cluster (`google_container_cluster`)
- Node pool configuration
- RBAC enablement
- Private cluster option

#### [NEW] Module: `platform/terraform/modules/storage/`
- Storage accounts / S3 buckets / GCS buckets
- Persistent volume provisioners
- Backup configuration

#### [NEW] Module: `platform/terraform/modules/monitoring/`
- Log Analytics / CloudWatch / Cloud Logging
- Prometheus workspace (managed)
- Grafana workspace (managed)

#### [NEW] Module: `platform/terraform/modules/identity/`
- Managed identities / IAM roles / Service accounts
- Workload identity federation
- RBAC bindings

#### [NEW] Module: `platform/terraform/modules/security/`
- Key Vault / Secrets Manager / Secret Manager
- Encryption keys
- Network policies

#### [NEW] Environment configurations
- `platform/terraform/environments/dev/` — Dev tfvars + backend config
- `platform/terraform/environments/qa/` — QA tfvars + backend config
- `platform/terraform/environments/uat/` — UAT tfvars + backend config
- `platform/terraform/environments/prod/` — Prod tfvars + backend config

#### [NEW] Root Terraform files
- `platform/terraform/main.tf` — Module composition
- `platform/terraform/variables.tf` — Input variables
- `platform/terraform/outputs.tf` — Output values
- `platform/terraform/providers.tf` — Provider configuration
- `platform/terraform/backend.tf` — Remote state with locking
- `platform/terraform/versions.tf` — Required provider versions

---

### Phase 4: Kubernetes & Helm

Base Kubernetes manifests and Helm chart structure.

#### [NEW] Kubernetes base manifests (`platform/kubernetes/base/`)
- `namespace.yaml`
- `deployment.yaml` — With probes, resources, security context
- `service.yaml`
- `ingress.yaml`
- `configmap.yaml`
- `hpa.yaml` — Horizontal Pod Autoscaler
- `pdb.yaml` — Pod Disruption Budget
- `networkpolicy.yaml`
- `kustomization.yaml`

#### [NEW] Kubernetes overlays
- `platform/kubernetes/overlays/dev/` — Dev patches
- `platform/kubernetes/overlays/qa/` — QA patches
- `platform/kubernetes/overlays/uat/` — UAT patches
- `platform/kubernetes/overlays/prod/` — Prod patches (higher replicas, stricter limits)

#### [NEW] Helm chart (`platform/kubernetes/helm/`)
- `Chart.yaml`
- `values.yaml` — Default values
- `values-dev.yaml`
- `values-qa.yaml`
- `values-uat.yaml`
- `values-prod.yaml`
- `templates/deployment.yaml` — Full deployment with all probes, limits, security context
- `templates/service.yaml`
- `templates/ingress.yaml`
- `templates/configmap.yaml`
- `templates/secret.yaml` — External secrets reference
- `templates/hpa.yaml`
- `templates/pdb.yaml`
- `templates/networkpolicy.yaml`
- `templates/serviceaccount.yaml`
- `templates/servicemonitor.yaml` — Prometheus ServiceMonitor
- `templates/_helpers.tpl`
- `templates/NOTES.txt`
- `.helmignore`

---

### Phase 5: Argo CD & GitOps

#### [NEW] Argo CD application definitions (`platform/argocd/applications/`)
- `application-template.yaml` — Templated Application CR
- `applicationset.yaml` — ApplicationSet for multi-env deployment
- `project.yaml` — AppProject with RBAC
- `dev-app.yaml` — Dev environment application
- `qa-app.yaml` — QA environment application
- `uat-app.yaml` — UAT environment application
- `prod-app.yaml` — Prod environment application (manual sync)

#### [NEW] Argo CD configuration
- `platform/argocd/argocd-cm.yaml` — ConfigMap customization
- `platform/argocd/argocd-rbac-cm.yaml` — RBAC policies
- `platform/argocd/notifications-cm.yaml` — Notification triggers (Slack, Teams)

#### [NEW] Deployment strategies
- `platform/argocd/strategies/rolling.yaml`
- `platform/argocd/strategies/canary.yaml`
- `platform/argocd/strategies/blue-green.yaml`

---

### Phase 6: Monitoring, Alerting & Observability

#### [NEW] Prometheus configuration (`monitoring/prometheus/`)
- `prometheus-config.yaml` — Scrape configs, service discovery
- `prometheus-rules.yaml` — Recording rules
- `servicemonitor-template.yaml` — ServiceMonitor CRD template

#### [NEW] Grafana dashboards (`monitoring/grafana/`)
- `dashboards/application-dashboard.json`
- `dashboards/infrastructure-dashboard.json`
- `dashboards/cluster-dashboard.json`
- `dashboards/api-dashboard.json`
- `datasources/prometheus-datasource.yaml`
- `datasources/tempo-datasource.yaml`
- `provisioning/dashboards.yaml` — Dashboard provisioner
- `provisioning/datasources.yaml` — Datasource provisioner

#### [NEW] Alert rules (`monitoring/alerts/`)
- `cpu-alerts.yaml` — High CPU
- `memory-alerts.yaml` — High Memory
- `pod-alerts.yaml` — Pod Restart, CrashLoopBackOff
- `latency-alerts.yaml` — High Latency
- `error-alerts.yaml` — High Error Rate
- `availability-alerts.yaml` — Service Unavailable
- `alertmanager-config.yaml` — Routes for Email, Slack, Teams

#### [NEW] OpenTelemetry (`observability/otel/`)
- `otel-collector-config.yaml` — Collector pipeline (receivers, processors, exporters)
- `otel-collector-deployment.yaml` — Collector K8s deployment
- `otel-collector-service.yaml`

#### [NEW] Auto-instrumentation (`observability/otel/collectors/`)
- `dotnet-instrumentation.yaml` — .NET auto-instrumentation CR
- `nodejs-instrumentation.yaml` — Node.js auto-instrumentation CR
- `python-instrumentation.yaml` — Python auto-instrumentation CR
- `java-instrumentation.yaml` — Java auto-instrumentation CR
- `go-instrumentation.yaml` — Go instrumentation sidecar config

---

### Phase 7: Security Policies

#### [NEW] Security policies (`security/policies/`)
- `no-privileged-containers.rego` — OPA policy: deny privileged
- `require-resource-limits.rego` — OPA policy: require limits
- `require-probes.rego` — OPA policy: require liveness/readiness
- `require-security-context.rego` — OPA policy: require security context
- `deny-latest-tag.rego` — OPA policy: deny `:latest` tag
- `require-labels.rego` — OPA policy: require standard labels

#### [NEW] Security scanning (`security/scanning/`)
- `trivy-config.yaml` — Trivy scanner configuration
- `checkov-config.yaml` — Checkov configuration
- `grype-config.yaml` — Grype configuration
- `codeql-config.yml` — CodeQL configuration

---

### Phase 8: Golden Templates & Backstage

#### [NEW] Golden template: .NET API (`golden-templates/dotnet-api/`)
- `src/Program.cs`
- `src/Controllers/HealthController.cs`
- `src/{{serviceName}}.csproj`
- `Dockerfile` — Multi-stage
- `.github/workflows/ci-cd.yml` — Calls reusable workflows
- `helm/` — Service-specific Helm chart
- `argocd/application.yaml`
- `otel/otel-config.yaml`
- `monitoring/servicemonitor.yaml`
- `docs/README.md`
- `catalog-info.yaml` — Backstage component registration

#### [NEW] Golden template: Node.js API (`golden-templates/node-api/`)
- `src/index.js`, `src/routes/health.js`
- `package.json`
- `Dockerfile`
- `.github/workflows/ci-cd.yml`
- `helm/`, `argocd/`, `otel/`, `monitoring/`, `docs/`, `catalog-info.yaml`

#### [NEW] Golden template: Python API (`golden-templates/python-api/`)
- `src/main.py`, `src/routes/health.py`
- `requirements.txt`
- `Dockerfile`
- `.github/workflows/ci-cd.yml`
- `helm/`, `argocd/`, `otel/`, `monitoring/`, `docs/`, `catalog-info.yaml`

#### [NEW] Golden template: React App (`golden-templates/react-app/`)
- `src/App.jsx`, `src/index.jsx`
- `package.json`
- `Dockerfile`
- `nginx.conf` — Production nginx config
- `.github/workflows/ci-cd.yml`
- `helm/`, `argocd/`, `otel/`, `monitoring/`, `docs/`, `catalog-info.yaml`

#### [NEW] Golden template: Worker Service (`golden-templates/worker-service/`)
- `src/Worker.cs`
- `Dockerfile`
- `.github/workflows/ci-cd.yml`
- `helm/`, `argocd/`, `otel/`, `monitoring/`, `docs/`, `catalog-info.yaml`

#### [NEW] Backstage templates (`backstage/templates/`)
- `dotnet-api-template.yaml` — Scaffolder template
- `node-api-template.yaml`
- `python-api-template.yaml`
- `react-app-template.yaml`
- `worker-service-template.yaml`

#### [NEW] Backstage catalog (`backstage/catalog/`)
- `catalog-info.yaml` — Root catalog
- `platform-system.yaml` — Platform system entity
- `platform-domain.yaml` — Platform domain entity
- `platform-group.yaml` — Platform team group

---

### Phase 9: Scripts & Documentation

#### [NEW] Automation scripts (`scripts/`)
- `bootstrap.sh` — One-command cluster bootstrap
- `generate-service.sh` — Generate new service from golden template
- `validate-all.sh` — Run all validations locally
- `setup-argocd.sh` — Install and configure Argo CD
- `setup-monitoring.sh` — Install Prometheus + Grafana stack
- `setup-otel.sh` — Install OpenTelemetry Collector

#### [NEW] Documentation (`docs/`)
- `architecture.md` — Architecture diagrams (Mermaid)
- `deployment-guide.md` — Step-by-step deployment
- `runbooks/high-cpu.md`
- `runbooks/pod-crashloop.md`
- `runbooks/high-latency.md`
- `runbooks/service-unavailable.md`
- `onboarding.md` — Developer onboarding guide
- `security.md` — Security practices
- `troubleshooting.md` — Common issues and fixes

---

## Verification Plan

### Automated Validation
After each phase, I will run:
```bash
# YAML validation
find . -name "*.yaml" -o -name "*.yml" | xargs yamllint

# Terraform validation
cd platform/terraform && terraform init -backend=false && terraform validate

# Helm lint
helm lint platform/kubernetes/helm/

# OPA policy test
conftest verify -p security/policies/
```

### Structural Verification
- Verify all 200+ files are created with non-placeholder content
- Verify every Kubernetes workload has: liveness probe, readiness probe, resource limits, security context
- Verify no privileged containers in any manifest
- Verify all 9 GitHub Actions workflows use `workflow_call`
- Verify Terraform modules have `variables.tf`, `outputs.tf`, `main.tf`

### Manual Verification
- Review generated golden template Dockerfiles for multi-stage best practices
- Verify Grafana dashboard JSON renders correctly
- Confirm Helm chart templates produce valid K8s manifests via `helm template`
