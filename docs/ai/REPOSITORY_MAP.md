# Repository Map

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Detailed Directory and File Mapping

Below is a complete index of all active paths in this repository:

- **`.github/`**: Workflow orchestrators and composite setups.
  - `workflows/01-validate.yml` to `09-backstage-sync.yml`: Reusable steps.
  - `workflows/ci-cd.yml`: Entry point caller pipeline.
- **`platform/`**: GitOps configurations and IaC.
  - `terraform/`: Multi-stage compositions, networking, IAM modules.
  - `kubernetes/`: Base K8s deployment manifests and Helm values.
  - `argocd/`: Sync definitions and rollout strategies.
- **`golden-templates/`**: Language microservice templates (.NET, Python, Node, React).
- **`security/`**: Local configuration files and OPA admission rego policies.
- **`monitoring/`**: Grafana dashboards and alert rules.
- **`scripts/`**: Master bootstrap and convenience automation scripts.
- **`docs/`**: Compliance, architecture, operational guides, and runbooks.
