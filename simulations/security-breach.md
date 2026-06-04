# Simulation 03: Security Breach (OPA Policy Enforcement)

## Incident Scenario
A developer attempts to deploy a misconfigured application container running with root user permissions and capabilities, triggering security policies rejection.

## Symptoms & Metrics
- **Pipeline Status**: Reusable build validation stage fails on OPA tests.
- **Argo CD Status**: Synchronization fails with admission webhook rejection error messages.

## Step-by-Step Investigation
1. Inspect pipeline log errors to identify violating resources:
   ```bash
   conftest test -p security/policies/ platform/kubernetes/base/deployment.yaml
   ```
2. Verify if the deployment specifies `runAsNonRoot: false` or mounts host namespaces.

## Recovery Procedures
1. Restrict privileged access by applying container security context limits:
   ```yaml
   securityContext:
     runAsNonRoot: true
     allowPrivilegeEscalation: false
     capabilities:
       drop:
         - ALL
   ```
2. Commit hardened manifests to the Git repository.
