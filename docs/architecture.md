# Architecture Design & Workflow

This document describes the high-level architecture, pipeline flows, and component layouts for the Platform Engineering Accelerator.

## High-Level Architecture Flow

The following Mermaid diagram shows the workflow from developer commits to GitOps-driven deployment and monitoring:

```mermaid
graph TD
    Dev[Developer] -->|Git Push| Repo[GitHub Repo]
    Repo -->|Trigger| GHA[GitHub Actions]
    
    subgraph CI Pipeline
        GHA --> Val[01-Validate]
        GHA --> Sec[02-Security]
        Val --> Build[03-Build]
        Sec --> Build
        Build --> Test[04-Test]
    end

    subgraph CD Pipeline
        Test --> Cont[05-Containerize]
        Cont --> Pub[06-Publish]
        Pub -->|Push Image| GHCR[Container Registry - GHCR]
        Pub --> GitOps[07-GitOps Update]
        GitOps -->|Update Image Tag| GitOpsRepo[GitOps manifests / branch]
    end

    subgraph CD GitOps
        Argo[Argo CD] -->|Scrapes| GitOpsRepo
        Argo -->|Syncs state| K8s[Kubernetes Cluster]
    end

    subgraph Observability Stack
        K8s -->|Logs / Metrics / Traces| OTEL[OpenTelemetry Collector]
        OTEL --> Prometheus[Prometheus]
        OTEL --> Tempo[Tempo / Jaeger]
        Prometheus --> Grafana[Grafana Dashboards]
    end

    subgraph Developer Portal
        Backstage[Backstage] -->|Reads| Repo
        Backstage -->|Syncs metrics| Grafana
    end
```

## Component Architecture

1. **Self-Service**: Developers use Backstage Software Templates to register, bootstrap, and deploy services from pre-configured golden templates.
2. **CI/CD**: Workflows are fully componentized and reusable. No duplicated steps.
3. **Infrastructure as Code**: Cloud-agnostic modules provision isolated Virtual Networks, Managed Kubernetes Clusters (AKS/EKS/GKE), Managed Identity, and Key Management.
4. **GitOps Git Engine**: Argo CD maps states in Git to live Kubernetes states. Environments are isolated by namespaces and monitored via Prometheus recording rules.
