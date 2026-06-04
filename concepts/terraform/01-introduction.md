# Terraform Concepts — Part 1: Foundations

| Attribute | Value |
| --- | --- |
| **Owner** | Platform Engineering Team |
| **Version** | v1.0.0 |
| **Last Updated** | 2026-06-04 |
| **Generation Timestamp** | 2026-06-04T13:55:00Z |
| **Source References** | [concepts/terraform](file:///h:/devopsprod4jun26/concepts/terraform/) |
| **Validation Status** | APPROVED |

---

## 1. Introduction & History
Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp in 2014. It uses a declarative configuration language (HCL - HashiCorp Configuration Language) to provision cloud resources.

## 2. Declarative vs Imperative
- **Declarative (Terraform)**: You declare the target state (e.g. "I want 3 virtual machines"), and Terraform calculates the steps to achieve it.
- **Imperative (Bash, CLI)**: You write explicit commands specifying how to build each resource step-by-step.

## 3. Core State Mechanism
Terraform tracks the relationship between configurations and live infrastructure using a local or remote `terraform.tfstate` file.
- **Locking**: Prevents concurrent executions from corrupting states.
- **Drift Detection**: Runs comparisons between config files, state cache, and live resources.
