# Simulation 01: Pod Failure (CrashLoopBackOff)

## Incident Scenario
An application pod is continuously restarting and failing to remain online, causing request timeouts.

## Symptoms & Metrics
- **K8s Status**: `CrashLoopBackOff` or `Error`.
- **Grafana Panels**: Active Connections drop to 0; HTTP Error Rate spikes.
- **AlertManager Notification**: `CrashLoopBackOff` alert triggered.

## Step-by-Step Investigation
1. Retrieve pod logs of the current or previous failed container:
   ```bash
   kubectl logs <pod-name> -n <namespace> --previous
   ```
2. Describe the pod details:
   ```bash
   kubectl describe pod <pod-name> -n <namespace>
   ```
   Check the `Last State` exit code:
   - **Exit Code 137**: OOMKilled. Pod ran out of memory.
   - **Exit Code 1**: Application threw an unhandled runtime exception.

## Recovery Procedures
- **If OOMKilled**: Edit environment values (`values-prod.yaml`) and increase memory limits under `resources.limits.memory` to 512Mi or 1024Mi. Commit changes to Git.
- **If App Crash**: Revert the last committed merge PR using Git and push, letting Argo CD sync.
