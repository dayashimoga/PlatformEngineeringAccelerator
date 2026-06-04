# Upgrade Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Tool and Chart Upgrade Process

### 1. Upgrade Helm Dependency Packages
To bump upstream Helm dependencies (e.g. Ingress Nginx or Kube-Prometheus-Stack charts):
1. Update chart registry versions inside [scripts/setup-monitoring.sh](file:///h:/devopsprod4jun26/scripts/setup-monitoring.sh) or [scripts/setup-argocd.sh](file:///h:/devopsprod4jun26/scripts/setup-argocd.sh).
2. Execute the setup target to apply the updated versions:
   ```bash
   make setup-monitoring
   ```

### 2. Terraform Provider Upgrades
1. Update constraint mappings in `platform/terraform/versions.tf`.
2. Re-initialize and update lock hashes:
   ```bash
   cd platform/terraform && terraform init -upgrade
   ```
3. Commit modified lock files (`.terraform.lock.hcl`).
