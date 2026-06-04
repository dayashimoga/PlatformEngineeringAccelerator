# Security Baseline

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Hardened Workload Baseline

All workloads deployed through this accelerator must comply with the following CIS Kubernetes benchmarks:

1. **Pod Security Standards (PSS)**:
   - Workloads must run under the `Restricted` profile (default settings in [base deployment.yaml](file:///h:/devopsprod4jun26/platform/kubernetes/base/deployment.yaml)).
2. **Admission Guardrails**:
   - Deny mounting host paths (`hostPath` volumes).
   - Require read-only root filesystems for all application containers.
3. **Control Plane Security**:
   - Node communication must utilize TLS 1.3 encryption.
   - API endpoints are restricted to specified corporate network ranges.
