# Performance Testing Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. Load Testing Standards
- **Tooling**: We recommend **k6** or **JMeter** to run performance validation.
- **Scenario Types**:
  - **Smoke Test**: 10 virtual users (VUs) for 5 minutes (validate basic performance).
  - **Load Test**: 100 VUs for 30 minutes (verify system under expected conditions).
  - **Stress Test**: Scale VUs until error rate exceeds 1% or latency exceeds 2 seconds.

## 2. Cluster Validation
During load tests, monitor:
- HPA triggers via `kubectl get hpa -w`.
- Node utilization and CPU throttling metrics on the **Infrastructure Dashboard**.
- Redis/Database connection pool limits.
