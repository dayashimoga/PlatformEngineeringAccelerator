# AI Operating Guide

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T12:15:00Z |
| **Source References** | [platform-engineering-accelerator](file:///h:/devopsprod4jun26) |
| **Validation Status** | APPROVED |

---

## Operating Guidelines for AI Coding Assistants

When editing, refactoring, or extending files in this repository, you must adhere to the following rules:

### 1. Code Preservation
- Maintain documentation integrity. Preserve all existing comments, parameter descriptions, and docstrings in code blocks unless explicitly instructed otherwise.
- Never write stub functions or mock placeholders in production files.

### 2. Security and Hardening Rules
- All newly added workloads must run under UID 1000 (non-root) and drop all capabilities.
- Secrets must never be stored in plaintext. Use Env Var injection references or CSI storage mounts.

### 3. Pipeline Integration
- After updating files, run `make validate-all` to ensure syntax, OPA validation rules, and Helm templates are valid.
- Any change to infrastructure must correspond to an update in the respective environment variables and variable descriptors.
