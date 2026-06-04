# Release Plan

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Versioning Strategy

This repository enforces **Semantic Versioning (SemVer)**:
- **Major**: Architectural redesign, breaking API changes, or CLI configuration modifications.
- **Minor**: Adding new golden templates or additional reusable workflows without breaking existing ones.
- **Patch**: Security updates, policy rules adjustment, or minor bug fixes in templates.

## Release Process

1. **Commit Message Format**: Developers must follow **Conventional Commits** format (e.g. `feat: ...`, `fix: ...`).
2. **Release Branches**: Release branches (`release/vX.Y`) are branched from `main`.
3. **Tags**: Git tags trigger the container and Helm charts publish pipelines (`06-publish.yml` and `08-release.yml`).
4. **Changelog**: Automatically compiled via conventional commits parse.
