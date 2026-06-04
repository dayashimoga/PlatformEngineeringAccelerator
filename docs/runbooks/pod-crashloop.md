# Runbook: Pod Restarting / CrashLoopBackOff

## Alert Name: `CrashLoopBackOff` or `PodRestart`

### Severity
- Critical (Pod in CrashLoopBackOff for 5m)
- Warning (Pod restarted > 3 times in 1h)

---

## 1. Initial Assessment

1. Find the crashlooping pod:
   ```bash
   kubectl get pods -n <namespace> | grep -E "CrashLoop|Error"
   ```

---

## 2. Diagnostics Steps

1. **Describe the Pod**: Check Events, Exit Codes, and Last State.
   ```bash
   kubectl describe pod <pod-name> -n <namespace>
   ```
   - **Exit Code 137**: Out Of Memory (OOMKilled). The container exceeded its memory limit.
   - **Exit Code 1**: Application exception (config error, runtime crash).
   - **Exit Code 0**: Application exited prematurely (usually due to lack of an active background listener or worker loop).

2. **Retrieve Logs of the CRASHED instance**:
   ```bash
   kubectl logs <pod-name> -n <namespace> --previous --tail=100
   ```

3. **Check ConfigMap & Secrets**: Ensure env variables or config dependencies mapped via ConfigMap exist and contain valid parameters.

---

## 3. Mitigation

- **If OOMKilled (Exit Code 137)**: Increase the memory limit in Helm values files (`values-<env>.yaml`).
- **If Runtime Error (Exit Code 1)**: Fix the application bug or database connection string parameter.
- **If Health Probe Failure**: Review startup/liveness probes timing configurations. Startup probes might need a higher `failureThreshold` or `initialDelaySeconds` if the app takes a long time to boot.
