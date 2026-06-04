# Build Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Packaging & Building Workloads

Workloads must use multi-stage Docker builds to produce optimized, secure, non-root OCI images.

### 1. Building Golden Templates Locally

#### .NET Web APIs & Workers:
```bash
cd golden-templates/dotnet-api
docker build -t local/dotnet-api:latest .
```
- **SDK Stage**: Uses `mcr.microsoft.com/dotnet/sdk:8.0-alpine` to compile.
- **Runtime Stage**: Copies artifacts to `mcr.microsoft.com/dotnet/aspnet:8.0-alpine`.

#### Node.js APIs:
```bash
cd golden-templates/node-api
docker build -t local/node-api:latest .
```

#### React SPA (with Nginx server):
```bash
cd golden-templates/react-app
docker build -t local/react-app:latest .
```
- **Builder Stage**: Packages production assets via Vite.
- **Server Stage**: Imports static assets into a hardened Nginx container, exposing port `8080`.
