# Lab 06: Policy Enforcement with OPA/Rego

## Lab Information
- **Difficulty**: Expert
- **Duration**: 45 minutes
- **Estimated Mastery Score**: +20 points

---

## 1. Goal
Write a custom Open Policy Agent (OPA) Rego policy that blocks Kubernetes deployments from mounting host filesystem paths (`hostPath` volumes), and verify the policy behavior.

---

## 2. Lab Tasks

### Task 1: Create the Rego policy
Create a file under `security/policies/deny-hostpath.rego`:
```rego
package kubernetes.admission

deny[msg] {
  input.kind == "Deployment"
  volume := input.spec.template.spec.volumes[_]
  volume.hostPath
  msg := sprintf("Deployment '%v' uses hostPath volume '%v' which is restricted.", [input.metadata.name, volume.name])
}
```

### Task 2: Validate a violating manifest
1. Create a dummy deployment file `bad-deploy.yaml` that mounts `/var/run/` from the host.
2. Run Conftest against this bad manifest:
   ```bash
   conftest test -p security/policies/ bad-deploy.yaml
   ```
3. Observe how the command fails, displaying the validation error.

---

## 3. Validation Steps
Run OPA validation checks:
```bash
make validate-policies
```
*Expected Output*: `PASS` or conftest output verify.
