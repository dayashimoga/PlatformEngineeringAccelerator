# Argo CD Concepts — Part 2: Operations & Sync Control

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [concepts/argocd](file:///h:/devopsprod4jun26/concepts/argocd/) |
| **Validation Status** | APPROVED |

---

## 1. Synchronization Mechanics
- **Self-Healing**: If a user runs manual commands (e.g. `kubectl scale`), Argo CD automatically detects the drift and overwrites changes back to matching git state.
- **Pruning**: Automatically deletes resources in the cluster if they are removed from the git repository.
- **Server-Side Apply**: Speeds up validation checks by passing manifest definitions directly to the api-server.

## 2. Advanced Rolling Strategies
By integrating **Argo Rollouts**, the CD engine can coordinate:
- **Canary Rollout**: Incremental traffic routing (e.g. 10% -> 25% -> 50% -> 100%) checking metrics via analysis templates.
- **Blue-Green**: Pre-provisions full replica sets alongside the live version, swapping traffic at the Ingress controller tier only after health validation.
