# Lab 04: GitOps CD with Argo CD

## Lab Information
- **Difficulty**: Advanced
- **Duration**: 45 minutes
- **Estimated Mastery Score**: +15 points

---

## 1. Goal
Configure Argo CD to track configuration changes in git and synchronize deployments across multiple environment namespaces.

---

## 2. Lab Tasks

### Task 1: Inspect application mapping
Open [applicationset.yaml](file:///h:/devopsprod4jun26/platform/argocd/applications/applicationset.yaml).
Understand how the ApplicationSet template works:
- It tracks paths in `platform/kubernetes/helm`.
- It iterates across an environment list (dev, qa, uat, prod).
- It injects values mapping to values files (e.g. `values-dev.yaml`).

### Task 2: Trigger configuration drift
1. Make manual modifications to a running pod's replica count in the cluster:
   ```bash
   kubectl scale deployment platform-service-dev -n dev --replicas=5
   ```
2. Navigate to the Argo CD UI portal.
3. Observe how the status transitions to `OutOfSync`. If self-healing is active, watch the controller immediately scale the deployment back to matches the git state.

---

## 3. Validation Steps
Run verify scripts to confirm Argo CD controller status:
```bash
make verify
```
*Expected Output*: `[PASS] ArgoCD Status - argocd-server is operational`
