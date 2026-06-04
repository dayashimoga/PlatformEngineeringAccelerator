# Runbook: High CPU Usage

## Alert Name: `HighCPUUsage` or `CriticalCPUUsage`

### Severity
- Warning (CPU > 85% for 5m)
- Critical (CPU > 95% for 2m)

---

## 1. Initial Assessment

1. Identify the failing pod and namespace from the alert payload or Grafana Infrastructure Dashboard.
2. Run kubectl command to view current resource consumption:
   ```bash
   kubectl top pods -n <namespace>
   ```

---

## 2. Diagnostics Steps

1. **Check Pod Logs**: See if the app is stuck in an infinite loop, parsing huge requests, or failing database calls.
   ```bash
   kubectl logs <pod-name> -n <namespace> --tail=200
   ```
2. **Review OpenTelemetry Tracing**: Visit Tempo/Jaeger portal and filter by the service name. Look for unusually long spans or trace spikes indicating slow CPU-bound processing.
3. **Check Throttling**:
   ```bash
   kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.status.containerStatuses[0].state}'
   ```

---

## 3. Mitigation

- **Option A (Horizontal Scaling)**: Scale deployment replicas temporarily to distribute traffic load.
  ```bash
  kubectl scale deployment <deployment-name> -n <namespace> --replicas=<current_replicas + 2>
  ```
- **Option B (Resource Adjustment)**: If the pod is constantly resource-starved under normal conditions, increase CPU requests/limits in the environment-specific Helm values (`values-prod.yaml` / `values-uat.yaml`).
- **Option C (Restart)**: Perform a rolling restart if a dead-lock or thread leak is suspected:
  ```bash
  kubectl rollout restart deployment <deployment-name> -n <namespace>
  ```
