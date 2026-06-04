# Lab 02: Terraform VPC Networking

## Lab Information
- **Difficulty**: Intermediate
- **Duration**: 45 minutes
- **Estimated Mastery Score**: +15 points

---

## 1. Goal
Configure and deploy a Virtual Network (VPC) with split public, private, and database subnet allocations, NAT Gateways, and Network Security Rules.

---

## 2. Lab Tasks

### Task 1: Initialize networking variables
Open [modules/networking/variables.tf](file:///h:/devopsprod4jun26/platform/terraform/modules/networking/variables.tf).
Declare CIDR ranges and subnet allocations:
```hcl
variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
```

### Task 2: Configure Route Tables and Subnets
Configure Terraform resources inside [modules/networking/main.tf](file:///h:/devopsprod4jun26/platform/terraform/modules/networking/main.tf) to:
- Bind a NAT Gateway to private subnets to allow outbound outbound routing.
- Restrict inbound SSH or RDP access inside Network Security Groups.

---

## 3. Validation Steps
Validate Terraform configurations:
```bash
cd platform/terraform
terraform init -backend=false
terraform validate
```
*Expected Output*: `Success! The configuration is valid.`
