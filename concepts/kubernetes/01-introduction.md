# Kubernetes Concepts — Part 1: Foundations

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [concepts/kubernetes](file:///h:/devopsprod4jun26/concepts/kubernetes/) |
| **Validation Status** | APPROVED |

---

## 1. Introduction & History
Kubernetes (K8s) is an open-source container orchestration engine originally developed by Google (internally known as Borg) and donated to the Cloud Native Computing Foundation (CNCF) in 2014. It automates container deployment, scaling, load balancing, and cluster networking.

## 2. The Problem It Solves
Before container orchestrators, managing distributed microservices involved manually assigning servers, handling IP mapping conflicts, writing custom restart scripts, and balancing traffic. Kubernetes abstract away the physical server tier, allowing developers to treat the cluster as a single pool of resources.

## 3. Core Concepts
- **Pods**: The smallest deployable unit. Houses one or more containers sharing network interfaces and storage volumes.
- **Deployments**: Declarative templates specifying pod replicas, rolling update constraints, and labels selectors.
- **Services**: Stable DNS names and load balancers directing client streams to target pods.
- **Namespaces**: Logical partitions dividing cluster workloads (e.g. dev, qa, prod).
