# Developer Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Developer Workflow

This guide details how developers create, modify, and test services inside this repository.

### 1. Bootstrapping a Service
To create a new service from a template, run:
```bash
make generate-service NAME=my-payment-api RUNTIME=node PORT=3000 REPLICAS=2
```

### 2. Implementing Logic
- Locate your generated code in the project directory.
- Ensure any additional endpoint maps are registered under the health routes so the probes pass.
- Write unit tests in your service folder (e.g. `npm test` or `dotnet test`).

### 3. Local Verification
Before committing code, verify formatting and policies:
```bash
make validate-all
```
This runs lints and tests OPA policies against Helm-rendered templates.
