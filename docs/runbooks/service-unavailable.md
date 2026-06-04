# Runbook: Service Unavailable

## Alert Name: `ServiceUnavailable` or `EndpointDown`

### Severity
- Critical (Service is down or has no endpoints available)

---

## 1. Initial Assessment

1. Test if the application is reachable externally:
   ```bash
   curl -I http://<app-ingress-url>/healthz
   ```
2. Verify if the pods are in a running state:
   ```bash
   kubectl get pods -n <namespace> -l app.kubernetes.io/name=<service-name>
   ```

---

## 2. Diagnostics Steps

1. **Verify Endpoint Selection**:
   If pods are running but the service has 0 endpoints, check if the selector labels on the Service match the template labels on the Deployment:
   ```bash
   kubectl describe svc <service-name> -n <namespace>
   kubectl get endpoints <service-name> -n <namespace>
   ```
2. **Check Ingress Routing**:
   Ensure the ingress controller is running and mapping requests correctly:
   ```bash
   kubectl describe ingress <ingress-name> -n <namespace>
   ```
3. **Verify Network Policies**:
   Check if a NetworkPolicy is blocking ingress/egress to the pod. Temporarily audit NetworkPolicies if needed:
   ```bash
   kubectl get netpol -n <namespace>
   ```

---

## 3. Mitigation

- **Recreate Pods**: Force restart all pods if they are unresponsive:
  ```bash
  kubectl rollout restart deployment <deployment-name> -n <namespace>
  ```
- **Sync GitOps state**: If there's configuration drift, manually sync the state in Argo CD to restore correct manifests.
- **Rollback Changes**: Revert the last merge PR if it caused the outage.
