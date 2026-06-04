# Secret Management Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Secrets Management Lifecycle

We strictly prohibit committing sensitive parameters (passwords, certificates, keys) to Git.

### 1. In-Cluster Secrets Ingestion
- **Azure Key Vault / AWS Secrets Manager**: Vault stores credentials.
- **External Secrets Operator**: Syncs secrets from the cloud Key Vault directly into Kubernetes Secret targets.
- **Secrets Store CSI Driver**: Mounts secrets as file volumes inside the container's RAM (`tmpfs`), preventing credentials from being saved to the local host disk.

### 2. Secret Leakage Prevention
- **Local Checks**: pre-commit hooks scan changes before commits.
- **CI scan**: Trivy inspects staged codebase configurations during `02-security.yml` runs.
