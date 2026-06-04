# Runbook: High Request Latency

## Alert Name: `HighLatency` or `CriticalLatency`

### Severity
- Warning (P95 Latency > 1s for 5m)
- Critical (P99 Latency > 5s for 2m)

---

## 1. Initial Assessment

1. Visit the Grafana **API Metrics Dashboard** to locate which routes are exhibiting high latency.
2. Cross-reference with the OpenTelemetry traces to identify where time is being spent (e.g. database query, external API calls, internal computation).

---

## 2. Diagnostics Steps

1. **Downstream Call Latency**: Check if downstream microservices or database engines are slowing down. Look at the database query execution times in your OpenTelemetry span traces.
2. **Resource Exhaustion**: A CPU or memory-constrained pod will experience high latency because of CPU throttling or excessive garbage collection.
   - Run `kubectl top pods -n <namespace>` and check if the pods are hitting CPU limits.
3. **Network Congestion**: Check NAT Gateway connections and network bandwidth metrics.

---

## 3. Mitigation

- **Scale Out**: Add instances of the service to reduce individual load.
  ```bash
  kubectl scale deployment <deployment-name> -n <namespace> --replicas=<new-value>
  ```
- **Scale Up Limits**: If CPU usage is close to the limit, update the resource limits in Helm configs.
- **Rollback**: If the latency spike coincided with a recent deployment, trigger a rollback in Argo CD or via git:
  ```bash
  git revert <commit-sha> && git push
  ```
