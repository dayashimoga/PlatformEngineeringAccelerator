# Argo CD Concepts — Part 1: Foundations

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [concepts/argocd](file:///h:/devopsprod4jun26/concepts/argocd/) |
| **Validation Status** | APPROVED |

---

## 1. What is Argo CD?
Argo CD is a declarative GitOps continuous delivery tool for Kubernetes. It runs as an in-cluster controller that continuously monitors active applications and compares them against the configurations specified in git.

## 2. The GitOps Principle
GitOps treats Git repositories as the single source of truth for infrastructure and application states:
1. Declarative descriptions of the system (e.g. Kubernetes manifests).
2. System state is versioned in Git.
3. Approved merges are applied automatically via agents.
4. Software agents detect and alert on configuration drift.

## 3. Core Objects
- **Application**: Restricts source directories in git and maps them to cluster namespaces.
- **ApplicationSet**: Generates multiple Application objects dynamically based on env matrices.
- **AppProject**: Logically groups applications, enforcing RBAC permissions and target namespaces.
