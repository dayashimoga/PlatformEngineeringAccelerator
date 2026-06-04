# Branch Protection & Repository Governance Policy

This document outlines the required branch protection rules and governance workflows for all projects in this organization.

## Branching Strategy

We follow a GitOps-driven trunk-based development workflow:
- `main` is the production branch.
- Feature branches (`feature/*`, `bugfix/*`, `hotfix/*`) are created from `main`.
- Direct commits to `main` are strictly forbidden.

## Branch Protection Rules (main)

The following rules must be enforced on the `main` branch:

### 1. Require Pull Request Reviews
- **Required Approvals**: Minimum of 1 review from a designated owner.
- **Dismiss stale pull request approvals**: Enabled. When new commits are pushed, existing approvals are dismissed.
- **Require review from Code Owners**: Enabled. Code Owners defined in [CODEOWNERS](file:///h:/devopsprod4jun26/CODEOWNERS) must approve any changes to their respective paths.

### 2. Require Status Checks
The following GitHub Actions jobs must pass successfully before a Pull Request can be merged:
- `validate` (linting, formatting, YAML checks, policy validation)
- `security` (Trivy filesystem, Checkov IaC, dependency vulnerabilities)
- `test` (unit and integration tests)

### 3. Require Commit Signatures
- All commits merged into `main` must be signed with GPG, SSH, or S/MIME keys.

### 4. Require Linear History
- Pull requests must be merged using **Squash and Merge** to maintain a clean linear git history.

### 5. Restrict Who Can Push
- Direct pushes to `main` are disabled for all users (including administrators).
- All changes must go through the Pull Request lifecycle.

## Release Gate & Promotion Process

1. **Development & QA**: PR merges to `main` trigger automatic deployment to the Dev and QA environments via GitOps (Argo CD).
2. **UAT (User Acceptance Testing)**: After validation in QA, a promotion PR is created for the UAT environment values.
3. **Production**: Deployments to Production are triggered by Git tags. A production release requires:
   - Approval from the Release Engineering team.
   - Successful run of the full CI/CD regression suite.
   - An approved change request ticket.
