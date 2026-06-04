# Debugging Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Troubleshooting In-Cluster Workloads

### 1. View Logs in Real-time
Retrieve stdout logs from pods:
```bash
kubectl logs -n <namespace> -l app.kubernetes.io/name=<service-name> --tail=100 -f
```

### 2. Inspect Pod Event Context
If a pod is stuck in `Pending` or `CrashLoopBackOff`, describe the deployment context:
```bash
kubectl describe pod -n <namespace> -l app.kubernetes.io/name=<service-name>
```
Look for events matching:
- `FailedScheduling`: Insufficient node resources.
- `OOMKilled`: Pod exceeded memory limit.
- `Liveness probe failed`: App is unresponsive on the mapped health path.

### 3. Interactive Shell Debugging
Since golden template runtime containers do not run with root permissions, use ephemeral debugging containers for host checks:
```bash
kubectl debug -it -n <namespace> <pod-name> --image=curlimages/curl --target=<container-name>
```
This launches a sidecar container to debug internal endpoints.
