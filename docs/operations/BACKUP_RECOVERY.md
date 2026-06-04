# Backup & Recovery Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. Backup Policies
- **Kubernetes States**: Cluster namespaces and CRDs are defined declaratively in Git. No manual backup is needed for stateless configurations.
- **Persistent Volumes**: Persistent Volume (PV) snapshots are scheduled hourly by storage classes.
- **Terraform States**: Terraform state files use remote storage backends with versioning enabled.

## 2. Recovery Procedures
- **Rebuilding Cluster**:
  ```bash
  # Step 1: Apply Terraform in active region
  cd platform/terraform && terraform apply -var-file=environments/prod/terraform.tfvars -auto-approve
  # Step 2: Bootstrap resources
  ./scripts/bootstrap.sh
  ```
- **Restoring PV Volumes**:
  Locate snapshot IDs in cloud console and create a new PersistentVolume pointing to the backup snapshot ID, then run Argo CD sync.
