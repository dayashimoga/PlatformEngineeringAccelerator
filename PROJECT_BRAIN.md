# Project Brain — Platform Engineering Accelerator

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v2.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## 1. Business Context
- **Purpose**: Provides cloud-native, secure-by-default, zero-touch infrastructure templates and continuous delivery blueprints.
- **Audience**: Platform engineers, developers, and security auditors.

## 2. System Context
- **Integrations**: Integrates GitHub Actions runners (CI), GHCR container registries, Argo CD GitOps controllers (CD), and OpenTelemetry Collector pipelines feeding Prometheus and Grafana dashboards.

## 3. Architecture Context
- **Standard Layout**: Networking (VNet/VPC) -> Cluster Control Plane (AKS/EKS/GKE) -> Argo CD Namespaces (dev, qa, uat, prod) -> Observability (Otel, Prometheus, Grafana).

## 4. Learning Context & AI Instructions
- **UPEMS Engine**: Employs an interactive learning engine (`learning/`), technology concept folders (`concepts/`), sandbox labs (`labs/`), and incident simulations (`simulations/`).
- **AI Behavior rules**: Start with foundational knowledge, leverage analogies, and never skip validation checks.

## 5. Project Status
- **Current State**: Active, fully documented, with automated local validation and verification.
- **Roadmap**: Multi-region cluster setups, Service Mesh integrations, and real-time cost auditing dashboards.
