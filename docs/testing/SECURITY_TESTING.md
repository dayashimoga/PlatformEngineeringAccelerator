# Security Testing Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Automated Security Verification

The platform verifies configurations declarative and programmatically:

1. **Static Scans (IaC & Container)**:
   - Checkov verifies Terraform modules against CIS Kubernetes benchmarks.
   - Trivy checks file changes for secrets before git commits.
2. **OPA Verification**:
   - Conftest parses the Helm chart output locally and denies modifications containing security policy violations (e.g. privileged container status).
3. **Dynamic Verification (DAST)**:
   - Run daily OWASP ZAP scans against dev/qa ingress domains to identify security loopholes (e.g. broken auth, cross-site scripting).
