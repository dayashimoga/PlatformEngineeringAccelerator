# Lab 03: Kubernetes Probes & Health Checks

## Lab Information
- **Difficulty**: Intermediate
- **Duration**: 30 minutes
- **Estimated Mastery Score**: +10 points

---

## 1. Goal
Harden a Kubernetes deployment manifest by declaring startup, liveness, and readiness probes to guarantee zero-downtime rolling updates.

---

## 2. Lab Tasks

### Task 1: Check existing deployment
Open [base/deployment.yaml](file:///h:/devopsprod4jun26/platform/kubernetes/base/deployment.yaml).
Notice the probe timings:
- **startupProbe**: Allows the app up to 150 seconds to initialize before liveness audits commence.
- **readinessProbe**: Checks if the container port is ready to serve HTTP traffic.

### Task 2: Configure probe mappings
Verify the app's internal routes match the endpoints declared in YAML:
- Program.cs maps `/healthz` to live checks, and `/ready` to ready checks.
- If we configure a probe path (e.g. `/ready`) pointing to a route that doesn't exist, Kubernetes will restart or refuse to route traffic to the container.

---

## 3. Validation Steps
1. Verify the manifests locally:
   ```bash
   make validate-all
   ```
2. Render and verify probe declarations:
   ```bash
   helm template test platform/kubernetes/helm | grep -E "livenessProbe|readinessProbe"
   ```
