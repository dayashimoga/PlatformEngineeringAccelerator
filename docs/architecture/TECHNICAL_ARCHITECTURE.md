# Technical Architecture

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Language & Runtime Choices

1. **Infrastructure**: Terraform (IaC) allows declarative cluster provisioning.
2. **Kubernetes Configuration**: Helm v3 handles packaging, values templating, and charts dependencies.
3. **Application Runtimes**:
   - `.NET 8`: High-throughput Enterprise APIs and background worker services.
   - `Node.js 20`: Fast lightweight microservices.
   - `Python 3.12`: Data or lightweight API wrappers (FastAPI).
   - `React 18`: Single Page Applications served by Nginx.

## Pipeline Toolchain Ecosystem

- **OPA (Open Policy Agent) / Conftest**: Enforces client-side validation rules on rendered Kubernetes manifests.
- **Trivy / Grype**: Inspects dependency tree libraries and OS base layers for vulnerabilities.
- **Checkov**: Scans Terraform configuration files for infrastructure misconfigurations.
- **Cosign / Syft**: Syft creates the SBOMs at build time, and Cosign attaches cryptographic signatures to build tags inside GHCR.
- **OpenTelemetry Collector**: Handles span/metric intake, processing (batching, attribute injection), and exporting to storage engines.
