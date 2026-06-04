# Component Context Model

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Component Layout & Responsibilities

This model specifies the context of components in the workspace:

- **Terraform Modules** ([source](file:///h:/devopsprod4jun26/platform/terraform/modules/)):
  - Defines the core virtual networking, Kubernetes AKS/EKS/GKE cluster, IAM Workload Identity mapping, and log vaults resources.
- **Helm Package Chart** ([source](file:///h:/devopsprod4jun26/platform/kubernetes/helm/)):
  - Declares deployment templates, ConfigMaps, Ingress paths, NetworkPolicies, and ServiceMonitors.
- **Golden Templates** ([source](file:///h:/devopsprod4jun26/golden-templates/)):
  - Service code blueprints, Dockerfiles, and calling workflows used for self-service bootstrapping.
- **Security Policies** ([source](file:///h:/devopsprod4jun26/security/policies/)):
  - Rego constraints evaluated by OPA Admission controllers to block invalid deployments.
