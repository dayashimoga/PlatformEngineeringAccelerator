# Data Architecture

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Storage & Persistent Volumes

1. **Kubernetes StorageClasses**: Configured under the [storage module](file:///h:/devopsprod4jun26/platform/terraform/modules/storage/main.tf). Standardizes local SSD (e.g. premium-ssd on Azure, gp3 on AWS) with dynamic provisioning.
2. **PersistentVolumeClaims (PVC)**: Workloads needing durable state attach PVC storage arrays using strict reclaim policies.
3. **External State Store**: Transactional databases and caching services (e.g. Postgres, Redis) must map outside the cluster via private endpoints to cloud managed databases.
4. **Data Protection**: Automatic volume snapshot backups are enabled in the storage provider settings.
