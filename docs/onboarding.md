# Developer Onboarding Guide

Welcome! This guide gets you up and running with the Platform Engineering Accelerator.

---

## 1. Local Development Setup

To validate, lint, and verify your configurations locally before committing, ensure you have the following installed:
- Docker Desktop or Minikube
- kubectl & Helm
- yamllint & Conftest

To run all local validations at once, run:
```bash
./scripts/validate-all.sh
```

---

## 2. Scaffolding a New Microservice

You can bootstrap a new service in under 30 seconds using our golden templates:

### Option A: Via Command Line (Local)
Run the generator script:
```bash
./scripts/generate-service.sh -n "my-new-api" -t "node-api" -o "./services/my-new-api"
```
This generates a Node.js Express service, pre-instrumented with OpenTelemetry, complete with Dockerfiles, Helm values, and Argo CD Application manifests.

### Option B: Via Backstage Developer Portal
1. Navigate to the Backstage UI.
2. Click **Create...** in the sidebar.
3. Select your desired runtime template (e.g., **.NET API Service Template**).
4. Fill in the service name, repository location, and owner team.
5. Click **Next** and **Create**. Backstage will automatically push the repository and register it in the catalog.

---

## 3. Deployment & CI/CD Lifecycle

Every template comes with a `.github/workflows/ci-cd.yml` caller pipeline:

1. **Pull Request Validation**:
   - Creating a PR to `main` triggers linting, security scans, unit tests, and policy verification.
2. **Merging to main (Dev/QA Promotion)**:
   - Merging triggers containerization, image signing, and pushes to GHCR.
   - The pipeline updates the image tag in `platform/kubernetes/helm/values-dev.yaml` and triggers Argo CD to sync.
3. **Release Tag (Prod Promotion)**:
   - Creating a Git release tag triggers production promotion (which requires manual sync in Argo CD for stability).
