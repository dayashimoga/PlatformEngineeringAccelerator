# Dependency Map

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Tooling & CLI Dependencies

This project relies on the following CLI binaries and packages:

- **Terraform Providers**:
  - `hashicorp/azurerm` (v3.0+)
  - `hashicorp/aws` (v5.0+)
  - `hashicorp/google` (v5.0+)
  - `hashicorp/kubernetes` (v2.0+)
- **Kubernetes Operators**:
  - **OpenTelemetry Operator** (v0.92.0): Manages telemetry collectors and injects SDK auto-instrumentation agents.
  - **Cert-Manager** (v1.13.2): Automates certificate generation and validates webhook endpoints.
  - **Argo Rollouts** (v1.6.0): Manages canary and blue-green deploy rollouts.
- **Scanners**:
  - **Checkov**: IaC static scan engine.
  - **Trivy**: Vulnerability scanner.
  - **Grype**: SBOM vulnerability gate.
