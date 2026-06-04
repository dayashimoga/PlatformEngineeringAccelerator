# Compliance Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Compliance Mapping: SOC2 & ISO 27001

We map standard compliance controls directly to automated gates:

| Audit Control | Requirement | Platform Implementation |
| --- | --- | --- |
| **Change Control** | Access restriction and PR review trails | GitHub branch protection rules + ArgoCD GitOps tracking |
| **Supply Chain Security** | Software inventory auditability | Syft SBOM generation + Cosign cryptographic image signatures |
| **Access Restriction** | Role-based permission controls | Argo CD RBAC ConfigMaps + Workload Identity integrations |
| **Vulnerability Gates** | Package vulnerability scans | Grype scan steps in GHA workflows blocking critical issues |
