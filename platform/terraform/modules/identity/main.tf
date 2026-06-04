# =============================================================================
# Identity Module — Managed Identity / IAM Roles / Service Accounts
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

# --- Azure Managed Identity + Workload Identity ---
resource "azurerm_user_assigned_identity" "workload" {
  count               = var.cloud_provider == "azure" && var.enable_workload_identity ? 1 : 0
  name                = "id-${local.resource_prefix}-workload"
  resource_group_name = "rg-${local.resource_prefix}-aks"
  location            = var.region
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "workload" {
  count               = var.cloud_provider == "azure" && var.enable_workload_identity ? 1 : 0
  name                = "fic-${local.resource_prefix}"
  resource_group_name = "rg-${local.resource_prefix}-aks"
  parent_id           = azurerm_user_assigned_identity.workload[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.kubernetes_oidc_issuer
  subject             = "system:serviceaccount:default:workload-sa"
}

# --- AWS IAM Roles for Service Accounts (IRSA) ---
data "aws_caller_identity" "current" {
  count = var.cloud_provider == "aws" ? 1 : 0
}

resource "aws_iam_role" "workload" {
  count = var.cloud_provider == "aws" && var.enable_workload_identity ? 1 : 0
  name  = "role-${local.resource_prefix}-workload"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current[0].account_id}:oidc-provider/${replace(var.kubernetes_oidc_issuer, "https://", "")}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.kubernetes_oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:default:workload-sa"
        }
      }
    }]
  })

  tags = var.tags
}

# --- GCP Workload Identity ---
resource "google_service_account" "workload" {
  count        = var.cloud_provider == "gcp" && var.enable_workload_identity ? 1 : 0
  account_id   = "sa-${local.resource_prefix}-wl"
  display_name = "Workload Identity SA for ${local.resource_prefix}"
}

resource "google_service_account_iam_binding" "workload_identity" {
  count              = var.cloud_provider == "gcp" && var.enable_workload_identity ? 1 : 0
  service_account_id = google_service_account.workload[0].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${data.google_project.current[0].project_id}.svc.id.goog[default/workload-sa]"
  ]
}

data "google_project" "current" {
  count = var.cloud_provider == "gcp" ? 1 : 0
}
