# User Acceptance Testing (UAT) Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Promotion & Acceptance Gates

Before promoting changes to UAT, verify compliance with the following checklist:

### Acceptance Criteria Checklist

- [ ] **Linear Commit History**: Git log check verifies no merge commits exist on `main`.
- [ ] **Validation Run**: `make validate-all` returns a successful output.
- [ ] **Security Clear**: Checkov and Trivy scan files return 0 `HIGH` or `CRITICAL` vulnerability errors.
- [ ] **Signing Verified**: Container image signature has been validated using Cosign.
- [ ] **Integration Verification**: QA namespace smoke tests pass successfully.
- [ ] **Approvals**: Minimum of 1 code owner review approval is logged on the Promotion PR.
