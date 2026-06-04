# Monitoring Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Observability Dashboard Integration

We monitor infrastructure and workloads via 4 pre-configured dashboards in Grafana:

1. **Application Dashboard** ([details](file:///h:/devopsprod4jun26/monitoring/grafana/dashboards/application-dashboard.json)): Monitors request volume, HTTP error percentages, latency buckets, and active connections.
2. **Infrastructure Dashboard** ([details](file:///h:/devopsprod4jun26/monitoring/grafana/dashboards/infrastructure-dashboard.json)): Tracks CPU core usage, memory footprint working set, pod restarts count, and network IO.
3. **Cluster Dashboard**: Displays node CPU limits, scheduling queue capacities, and memory pressures.
4. **API Metrics Dashboard** ([details](file:///h:/devopsprod4jun26/monitoring/grafana/dashboards/api-dashboard.json)): Maps endpoints traffic, HTTP status distribution, and rate-limiting blocks.

## Alerting Triggers

Rules are defined in [platform-alerts.yaml](file:///h:/devopsprod4jun26/monitoring/alerts/platform-alerts.yaml) and route alerts (Slack / Email) through AlertManager based on severity:
- `CriticalCPUUsage` (CPU > 95% for 2m) -> Pages team.
- `CrashLoopBackOff` (Pod crash looping for 5m) -> Logs critical alert.
- `HighErrorRate` (Error rate > 5% for 5m) -> Slack channel warning.
