# Kubernetes Concepts — Part 2: Operations & Security

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [concepts/kubernetes](file:///h:/devopsprod4jun26/concepts/kubernetes/) |
| **Validation Status** | APPROVED |

---

## 1. Security Baseline
Workloads must follow standard hardening baselines:
- **Non-Root runtime**: Always specify `runAsNonRoot: true` in the pod's securityContext.
- **Capabilities**: Drop all default kernel capabilities (`capabilities.drop: [ALL]`) to prevent container escapes.
- **Read-Only Root**: Set `readOnlyRootFilesystem: true` to prevent write access to container root partitions.

## 2. Monitoring & Metrics
Prometheus scrapes core pod metrics via annotations or ServiceMonitor configurations.
- **Key SLIs**: Pod restart rate, CPU throttling count, memory working set utilization vs limits, HTTP error percentages.

## 3. Scaling & HPA
- Kubernetes scales instances automatically via the Horizontal Pod Autoscaler (HPA) using metrics queries.
- Under-provisioned node groups trigger cluster auto-scaling directly in the cloud provider.

## 4. Common Anti-Patterns
- **Using :latest tags**: Breaks build reproducibility.
- **Missing Probes**: Pods receive traffic before they are initialized, causing HTTP 502/503 errors.
- **Direct Pod deployments**: Deploying pods without deployments blocks automatic replication and healing.
