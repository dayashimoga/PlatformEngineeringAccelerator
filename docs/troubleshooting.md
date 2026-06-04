# Troubleshooting Guide

This document describes resolutions for common issues encountered during local development, deployment, and operation of platform resources.

---

## 1. Argo CD Sync Failures & Configuration Drift

### Symptom: OutOfSync state in Argo CD interface
- **Cause**: Manual edits in the cluster (e.g. `kubectl edit`) have caused drift from the Git repository state.
- **Resolution**:
  1. Open the application in the Argo CD UI.
  2. Click **App Diff** to see the differences.
  3. Click **Sync** -> check **Prune** and **Force** to restore the state defined in Git.
  4. Avoid direct manual edits; commit changes to Git instead.

---

## 2. OpenTelemetry Collector Connectivity Issues

### Symptom: Application logs error `Failed to export traces: deadline exceeded`
- **Cause**: The application cannot resolve or reach the collector service address.
- **Resolution**:
  1. Verify the collector is running in the `observability` namespace:
     ```bash
     kubectl get pods -n observability -l app.kubernetes.io/name=otel-collector
     ```
  2. Ensure the environment variable `OTEL_EXPORTER_OTLP_ENDPOINT` is configured correctly:
     - Default: `http://otel-collector.observability:4317` (gRPC) or `http://otel-collector.observability:4318` (HTTP).
  3. Test connectivity inside the application's pod namespace:
     ```bash
     kubectl run curl-test --image=curlimages/curl -it --rm -n dev -- curl -v http://otel-collector.observability:4317
     ```

---

## 3. Terraform State Lock

### Symptom: Error `Error acquiring the state lock` during terraform apply
- **Cause**: Another Terraform execution is currently applying changes or did not release the lock cleanly.
- **Resolution**:
  1. Find the Lock Info ID from the console output.
  2. If you are certain no other pipeline is running, force unlock:
     ```bash
     terraform force-unlock <lock-id>
     ```

---

## 4. Helm Release Locked

### Symptom: Error `another operation (install/upgrade/rollback) is in progress`
- **Cause**: A previous Helm command failed or was terminated abruptly.
- **Resolution**:
  1. Identify the status of the release:
     ```bash
     helm list -n <namespace>
     ```
  2. If the status is `pending-upgrade` or `pending-install`, rollback or delete the release:
     ```bash
     helm rollback <release-name> <last-successful-revision> -n <namespace>
     ```
