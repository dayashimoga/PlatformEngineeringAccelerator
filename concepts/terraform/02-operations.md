# Terraform Concepts — Part 2: Operations & Modular Design

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [concepts/terraform](file:///h:/devopsprod4jun26/concepts/terraform/) |
| **Validation Status** | APPROVED |

---

## 1. Remote State Management
For enterprise platforms, state files must be stored in secure remote backends (e.g. AWS S3, Azure Blob, HashiCorp Terraform Cloud):
- State versioning must be enabled to allow rollback in case of corruption.
- Dynamodb or Blob leases must be configured to enforce state locking.

## 2. Workspaces vs Modules
- **Modules**: Reusable resource blocks (e.g., [platform/terraform/modules/networking/](file:///h:/devopsprod4jun26/platform/terraform/modules/networking/)) parameterized via inputs.
- **Workspaces**: Isolated instances of the same composition mapped to target environments (dev, qa, prod) using env-specific variables.

## 3. Best Practices & Anti-patterns
- **Anti-pattern**: Committing state files containing secrets (passwords/keys) to Git repositories.
- **Best Practice**: Use `sensitive = true` on variable outputs to suppress secret prints in CLI logs.
