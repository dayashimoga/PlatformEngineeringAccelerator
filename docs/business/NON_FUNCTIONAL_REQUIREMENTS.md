# Non-Functional Requirements

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. Reliability & Availability
- **Uptime SLA**: System infrastructure must guarantee 99.9% uptime for core workloads.
- **Failover (RTO/RPO)**: Recovery Time Objective (RTO) must be < 4 hours; Recovery Point Objective (RPO) must be < 1 hour via automated state backup.

## 2. Scalability
- **Pod Autoscale**: Horizontal Pod Autoscaling (HPA) must scale replicas within 60 seconds when CPU utilization exceeds 70%.
- **Cluster Autoscaler**: Under-provisioned node groups must scale automatically based on pod scheduling queues.

## 3. Security & Governance
- **Least Privilege**: Zero direct access to production clusters. Changes must be pushed via Argo CD using GitOps.
- **Rootless Runtime**: 100% of workload containers must deny privilege escalation and run as a non-root user.

## 4. Performance
- **Ingress Latency**: Ingress Controller routing overhead must remain < 50ms under normal load.
