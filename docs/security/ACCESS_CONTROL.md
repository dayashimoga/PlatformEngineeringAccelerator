# Access Control Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Role-Based Access Control (RBAC)

The platform restricts user and workload activities using granular RBAC roles:

### 1. Workload Identity
- Configured via the [identity module](file:///h:/devopsprod4jun26/platform/terraform/modules/identity/main.tf).
- Maps Kubernetes service accounts directly to cloud service accounts, eliminating static credentials (passwords/tokens) from K8s secrets.

### 2. Argo CD RBAC Controls
- Defined at [argocd-rbac-cm.yaml](file:///h:/devopsprod4jun26/platform/argocd/argocd-rbac-cm.yaml).
- `role:readonly`: Default group access policy.
- `role:developer`: Grants sync permission on `dev` and `qa` namespaces.
- `role:release-manager`: Full CRUD on all namespaces (dev, qa, uat, prod).
