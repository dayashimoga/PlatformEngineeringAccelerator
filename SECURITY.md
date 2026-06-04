# Security Policy

## Supported Versions

| Version | Supported |
|---|---|
| Latest `main` | ✅ |
| Release branches | ✅ |
| Older releases | ❌ |

---

## Reporting a Vulnerability

**Do NOT open a public issue for security vulnerabilities.**

### Reporting Process

1. **Email**: Send details to `security@your-org.com`
2. **Subject**: `[SECURITY] Platform Engineering Accelerator — <brief description>`
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Affected components
   - Potential impact
   - Suggested fix (if any)

### Response Timeline

| Action | SLA |
|---|---|
| Acknowledge receipt | 24 hours |
| Initial assessment | 48 hours |
| Patch development | 7 days (critical), 30 days (high) |
| Public disclosure | After patch release |

---

## Security Practices

### Automated Security

This repository enforces security through automated scanning at every stage:

| Stage | Tool | Purpose |
|---|---|---|
| Code | CodeQL | Static analysis & vulnerability detection |
| Dependencies | Grype | Known vulnerability scanning |
| Secrets | GitHub Secret Scanning | Credential leak prevention |
| IaC | Checkov | Infrastructure-as-Code policy enforcement |
| Containers | Trivy | Container image vulnerability scanning |
| Supply Chain | Syft + Cosign | SBOM generation & image signing |
| Runtime | OPA/Gatekeeper | Kubernetes admission control |

### Container Security

- All images use multi-stage builds with minimal base images
- Images are signed with Cosign
- SBOMs are generated and attached to every image
- No containers run as root
- Read-only root filesystems enforced
- No privileged containers allowed

### Infrastructure Security

- All Terraform changes require plan review
- Network policies enforce pod-to-pod communication rules
- Secrets managed via external secret stores (not in-cluster)
- RBAC enforced with least-privilege principles
- Workload Identity used for cloud provider authentication

### Supply Chain Security

- All workflow actions pinned to specific SHA commits
- Dependency updates automated via Dependabot/Renovate
- SBOM generated for every build artifact
- Signed commits required for production branches

---

## Security Contacts

| Role | Contact |
|---|---|
| Security Lead | `security@your-org.com` |
| Platform Team | `platform-team@your-org.com` |
| Incident Response | `incident@your-org.com` |
