# Architecture Context for AI Agents

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Technical Design Archetypes

AI coding assistants must strictly adhere to the following design patterns:

### 1. Reusable Workflow Caller Pattern
- Reusable workflows are defined in `.github/workflows/` and invoked with the `uses` tag.
- Never write custom build steps directly in calling workflows; leverage the reusable steps.

### 2. Cloud-Agnostic Terraform Composition
- The platform uses a central `main.tf` orchestrator that routes variables to platform modules (`platform/terraform/modules/`).
- When introducing resource upgrades, update modules first, then root definitions.

### 3. GitOps Synchronization Architecture
- Workload adjustments must target values files (`values-<env>.yaml`). Never modify live resources in place.
- Argo CD applications use ApplicationSets mapping to folder paths.
