# Feature Catalog

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. Golden Templates
- **Dotnet Core API**: Pre-integrated with OpenTelemetry tracing/metrics/logging and health endpoints.
- **Node.js Express API**: Auto-instrumented using OTel and Prometheus metrics.
- **Python FastAPI**: Light-weight, high-performance API template.
- **React SPA**: Production Nginx container with CSP and TLS configurations.
- **Worker Daemon**: Background processing template.

## 2. Reusable Pipelines
- **01-Validate**: Static linting, YAML validation, OPA checks.
- **02-Security**: Checkov IaC scanning, Trivy secret/filesystem checks, Grype SBOM validation.
- **05-Containerize**: Multi-stage rootless Docker builds, Cosign image signing, Syft SBOM generation.
- **07-GitOps Update**: Automatic Git-tag promotion and values file patch generation.

## 3. GitOps Core
- **ApplicationSets**: Automated synchronization generator for dev, qa, uat, and prod.
- **AppProject**: Granular RBAC configurations.
