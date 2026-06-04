# Test Coverage Specifications

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Code Coverage Thresholds

Our reusable test workflow [04-test.yml](file:///h:/devopsprod4jun26/.github/workflows/04-test.yml) enforces strict coverage rules before a build is authorized:

- **Minimum Line Coverage**: 80% globally across all language runtimes.
- **Branch Coverage**: 75% for critical business logic paths.
- **Vulnerability SLA**:
  - `CRITICAL` or `HIGH` vulnerabilities -> Must be resolved immediately (block build).
  - `MEDIUM` vulnerabilities -> Remediate within 30 days.
  - `LOW` vulnerabilities -> Audited during periodic reviews.
- **IaC Checkov Violations**: Zero allowed misconfigurations in production configurations.
