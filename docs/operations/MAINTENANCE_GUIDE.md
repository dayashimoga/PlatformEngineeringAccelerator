# Maintenance Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Standard Maintenance Activities

### 1. VM Node Recycling
To rotate cluster nodes without interrupting workloads:
```bash
# Step 1: Cordone the node to prevent new pods scheduling
kubectl cordon <node-name>
# Step 2: Evict existing pods safely (PDB ensures availability)
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
```

### 2. Minor Kubernetes Upgrades
- Upgrade control plane versions using Terraform configurations by changing `kubernetes_version` in `terraform.tfvars`.
- Apply changes in sequence: dev -> qa -> uat -> prod.

### 3. Cleanup Routine
Run the clean target periodically to prune temp tfplans and local scanning logs:
```bash
make clean
```
