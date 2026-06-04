# Integration Testing Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. Cross-Service Contract Validation
- **Tooling**: We recommend using **Pact** for consumer-driven contract testing.
- **Goal**: Ensure microservices can communicate without parsing errors or schema mismatches. Contract tests verify endpoints before deployments are synchronized.

## 2. Cluster Integration Validation
After deploying workloads:
1. Run automated curl scripts to test database API endpoint pathways.
2. Verify that network policies block access from invalid namespaces (e.g. testing ingress from `dev` to `prod` is denied).
3. Validate that the OpenTelemetry Collector processes and forwards spans during test requests.
