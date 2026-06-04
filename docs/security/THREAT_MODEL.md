# Threat Model

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## System Threat Landscape

We identify and mitigate security threats using STRIDE classifications:

| Threat Vector | Target | Mitigation Strategy | Reference |
| --- | --- | --- | --- |
| **Tampering** | Container images in GHCR | Cryptographic tags signing and verification | [Cosign signing](file:///h:/devopsprod4jun26/.github/workflows/05-containerize.yml) |
| **Information Disclosure** | Hardcoded secrets in code | Git pre-commit hooks and Trivy scan gates | [Trivy scan](file:///h:/devopsprod4jun26/.github/workflows/02-security.yml) |
| **Denial of Service** | Host resource starvation | Enforcing CPU and Memory requests/limits | [OPA policy](file:///h:/devopsprod4jun26/security/policies/require-resource-limits.rego) |
| **Elevation of Privilege** | Container escape exploits | Enforcing non-root run profiles and drop capabilities | [OPA policy](file:///h:/devopsprod4jun26/security/policies/no-privileged-containers.rego) |
