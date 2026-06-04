# Contributing to Platform Engineering Accelerator

Thank you for contributing to the Platform Engineering Accelerator! This document provides guidelines for contributing to this repository.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Branching Strategy](#branching-strategy)
- [Commit Conventions](#commit-conventions)
- [Pull Request Process](#pull-request-process)
- [Code Review Standards](#code-review-standards)
- [Testing Requirements](#testing-requirements)

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you are expected to uphold this code.

---

## Getting Started

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a feature branch from `main`
4. **Make** your changes
5. **Test** your changes locally
6. **Commit** with conventional commit messages
7. **Push** your branch
8. **Open** a Pull Request

### Prerequisites

```bash
# Install required tools
make setup-tools

# Validate your environment
make validate-all
```

---

## Branching Strategy

```
main                    Production-ready code
├── release/*           Release candidates
├── feature/*           New features
├── fix/*               Bug fixes
├── hotfix/*            Production hotfixes
└── chore/*             Maintenance tasks
```

| Branch Pattern | Purpose | Base Branch | Merge Target |
|---|---|---|---|
| `feature/*` | New features | `main` | `main` |
| `fix/*` | Bug fixes | `main` | `main` |
| `hotfix/*` | Production fixes | `main` | `main` + `release/*` |
| `chore/*` | Maintenance | `main` | `main` |
| `release/*` | Release prep | `main` | `main` |

---

## Commit Conventions

We use [Conventional Commits](https://www.conventionalcommits.org/) for automated versioning and changelog generation.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting (no code change) |
| `refactor` | Code refactoring |
| `perf` | Performance improvement |
| `test` | Adding tests |
| `chore` | Maintenance tasks |
| `ci` | CI/CD changes |
| `security` | Security improvements |

### Scopes

| Scope | Description |
|---|---|
| `workflows` | GitHub Actions workflows |
| `terraform` | Infrastructure code |
| `kubernetes` | K8s manifests |
| `helm` | Helm charts |
| `argocd` | Argo CD configuration |
| `monitoring` | Prometheus/Grafana |
| `otel` | OpenTelemetry |
| `backstage` | Backstage templates |
| `security` | Security policies |
| `templates` | Golden templates |

### Examples

```bash
feat(workflows): add container image signing with Cosign
fix(helm): correct HPA target CPU utilization threshold
docs(runbooks): add high-latency troubleshooting guide
ci(workflows): enable parallel security scanning
security(policies): add OPA policy for network policy enforcement
```

---

## Pull Request Process

### Before Opening a PR

1. ✅ All CI checks pass locally (`make validate-all`)
2. ✅ No secrets or credentials in code
3. ✅ Documentation updated if needed
4. ✅ Helm charts lint successfully (`helm lint`)
5. ✅ Terraform validates (`terraform validate`)
6. ✅ OPA policies pass (`conftest verify`)

### PR Template

All PRs must include:
- **Description** of the change
- **Type** of change (feature, fix, breaking change)
- **Testing** performed
- **Screenshots** if applicable (especially for Grafana dashboards)
- **Breaking changes** documentation

### Required Approvals

| Target | Required Reviewers | Min Approvals |
|---|---|---|
| `main` | CODEOWNERS | 2 |
| Production configs | `@devops-leads` + `@platform-engineering-team` | 2 |
| Security policies | `@security-team` | 1 |
| Alert rules | `@sre-team` | 1 |

---

## Code Review Standards

### Terraform

- [ ] Modules have `variables.tf`, `outputs.tf`, `main.tf`
- [ ] All variables have descriptions and types
- [ ] Sensitive values marked as `sensitive = true`
- [ ] Remote state configured
- [ ] No hardcoded values

### Kubernetes / Helm

- [ ] All pods have liveness and readiness probes
- [ ] Resource requests and limits defined
- [ ] Security context set (non-root, read-only filesystem)
- [ ] No privileged containers
- [ ] NetworkPolicies defined

### GitHub Actions

- [ ] Uses `workflow_call` for reusability
- [ ] Pinned action versions (SHA, not tags)
- [ ] No secrets in logs
- [ ] Artifacts uploaded for reports

---

## Testing Requirements

| Component | Test Method |
|---|---|
| Terraform | `terraform validate`, `terraform plan` |
| Helm | `helm lint`, `helm template` |
| K8s Manifests | `kubeconform`, `kubeval` |
| OPA Policies | `conftest verify` |
| GitHub Actions | Act (local runner) |
| Security | Trivy, Checkov, Grype |
