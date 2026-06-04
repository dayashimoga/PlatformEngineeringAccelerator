# Component Architecture

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Workspace Layout Components

The Platform Engineering Accelerator is composed of modular components:

```
/platform-engineering-accelerator
  ├── .github/workflows/      # Reusable CI/CD workflow pipeline components
  ├── backstage/              # Self-service templates and developer catalogs
  ├── golden-templates/       # Runtime templates (.NET API, Node API, Python, React, Worker)
  ├── monitoring/             # Observability dashboards and rules configuration
  ├── observability/          # OpenTelemetry ingestion collectors and configs
  ├── platform/
  │     ├── argocd/           # GitOps synchronization applications and configurations
  │     ├── kubernetes/       # Base K8s deployment manifests and Helm charts
  │     └── terraform/        # Cloud-agnostic infrastructure modules
  └── security/               # OPA policies and configuration schemas
```

## Component Interoperability

1. **Backstage templates** reference **golden-templates** to instantiate codebases.
2. **Golden-templates** call **reusable pipelines** (`.github/workflows/`) for CI/CD.
3. **CI/CD** updates image tags inside **platform/kubernetes/helm/values-<env>.yaml**.
4. **Argo CD** synchronizes Helm charts with **platform/kubernetes/base/** manifests.
5. **Observability collectors** scrape running microservices and forward metrics/logs.
