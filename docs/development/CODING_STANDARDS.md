# Coding Standards

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. General Principles
- **No Placeholders**: Never commit code with "TODO" or placeholder logic in critical paths.
- **Rootless Containers**: All custom Dockerfiles must use Alpine or distroless bases, define a non-root user, and run workloads under UID 1000.
- **Port Standardization**: Containerized web applications must listen on port `8080` internally.

## 2. Configuration & Variables
- **No Hardcoding**: Credentials, hostnames, or cluster URIs must never be written directly in code. Always load parameters via environment variables or map them through ConfigMaps.
- **Terraform Naming**: Use snake_case for Terraform resource names and variables. All variables must define a `type` and a `description`.

## 3. Kubernetes Manifest Specifications
- Workloads must specify CPU and Memory requests and limits.
- Deployments must configure liveness, readiness, and startup probes on mapped HTTP paths.
- Labels must include `app.kubernetes.io/name` and `app.kubernetes.io/component`.
