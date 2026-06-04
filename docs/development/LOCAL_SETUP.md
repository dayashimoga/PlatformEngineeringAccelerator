# Local Setup Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Setting up Your Local Machine

### 1. Required Host Tooling
Install the following utilities:
- **Kubectl**: [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/)
- **Helm v3**: [Helm Package Manager](https://helm.sh/docs/intro/install/)
- **Kind**: [Kubernetes in Docker](https://kind.sigs.k8s.io/) or **Minikube**
- **Docker**: [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Rancher Desktop
- **Terraform**: [HashiCorp CLI](https://developer.hashicorp.com/terraform/install)

### 2. Verify Installations
Run our convenience verify target to check if the tool paths are set up:
```bash
make setup-tools
```

### 3. Initialize Local Cluster
To spin up a local Kind cluster and bootstrap all services (Argo CD, monitoring, Otel, and policies) automatically, run:
```bash
make up
```
This runs the master startup pipeline script.
