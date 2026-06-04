# Security Policy & Governance

This document describes the security controls, static analysis checks, container hardening rules, and registry security mechanisms built into the platform engineering accelerator.

---

## 1. Static Security Analysis (CI/CD)

The platform runs four static analyzers in the pipeline:
- **Trivy**: Scrapes the code directory for vulnerability signatures and hardcoded secrets.
- **Checkov**: Validates all Terraform templates and Kubernetes manifests against CIS Benchmarks.
- **Grype**: Runs dependency security scans against SBOMs.
- **CodeQL**: Evaluates code logic for security flaws (e.g. injection attacks).

Any vulnerability categorized as `HIGH` or `CRITICAL` will fail the CI/CD pipeline immediately.

---

## 2. Container Hardening

All docker container templates comply with strict runtime isolation policies:
- **Non-Root Execution**: Every container defines a dedicated user with UID 1000 and runs as non-root (`runAsNonRoot: true`).
- **Read-Only Root Filesystem**: Write permissions on root filesystem are revoked (`readOnlyRootFilesystem: true`). Ephemeral logs/caches use `/tmp` backed by an `emptyDir` memory volume.
- **Drop Capabilities**: All Linux kernel capabilities are dropped (`capabilities.drop: [ALL]`).
- **No Privilege Escalation**: Privilege escalation is disabled (`allowPrivilegeEscalation: false`).

---

## 3. OPA Admission Control Policies

All deployments must comply with Open Policy Agent (OPA) validation rules before merge. The policy engine blocks:
1. Privileged containers.
2. Containers with undefined CPU/Memory limits.
3. Deployments with missing readiness, liveness, or startup probes.
4. Images using the `:latest` tag.
5. Deployments with missing standard metadata labels (`app.kubernetes.io/name`).

---

## 4. Supply Chain Security

- **Software Bill of Materials (SBOM)**: Syft automatically generates a full cycloneDX JSON SBOM for every built container.
- **Image Signing**: The pipeline uses Cosign to sign container images. The signature is pushed alongside the image to GHCR.
- **Verification**: In-cluster controllers verify image signatures before admitting containers.
