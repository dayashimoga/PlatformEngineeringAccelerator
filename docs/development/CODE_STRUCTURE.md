# Code Structure

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Repository Map & File Organization

The workspace code is arranged logically by functional responsibilities:

- **`.github/`**: Houses pipeline workflow templates.
  - **`workflows/`**: Reusable steps (`01-validate.yml` to `09-backstage-sync.yml`) and `ci-cd.yml` orchestrator.
  - **`actions/`**: Composite actions (`setup-tools`, `docker-build`, `security-scan`) encapsulating runner steps.
- **`platform/`**: Platform-wide configuration files.
  - **`terraform/`**: Root deployment files (`main.tf`, `variables.tf`) and modular components (`networking/`, `kubernetes/`, `storage/`).
  - **`kubernetes/`**: Base manifests defining namespace, pdb, hpa, network policies, and the Helm package chart configurations.
  - **`argocd/`**: Defines synchronization parameters and strategies (rolling, canary, blue-green).
- **`golden-templates/`**: Boilerplates for .NET, Node.js, Python, and React applications.
- **`security/`**: Admission rules (Rego policies) and local validation configurations.
- **`monitoring/`**: Grafana dashboards, datasource specifications, and Prometheus alerts rules.
