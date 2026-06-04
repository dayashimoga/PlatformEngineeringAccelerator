# =============================================================================
# Security Module — Key Vault / Secrets Manager / Secret Manager
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

# --- Azure Key Vault ---
data "azurerm_client_config" "current" {
  count = var.cloud_provider == "azure" ? 1 : 0
}

resource "azurerm_resource_group" "security" {
  count    = var.cloud_provider == "azure" && var.enable_key_vault ? 1 : 0
  name     = "rg-${local.resource_prefix}-security"
  location = var.region
  tags     = var.tags
}

resource "azurerm_key_vault" "main" {
  count                      = var.cloud_provider == "azure" && var.enable_key_vault ? 1 : 0
  name                       = "kv-${local.resource_prefix}"
  location                   = var.region
  resource_group_name        = azurerm_resource_group.security[0].name
  tenant_id                  = data.azurerm_client_config.current[0].tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  enable_rbac_authorization = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = length(var.allowed_ip_ranges) > 0 ? "Deny" : "Allow"
    ip_rules                   = var.allowed_ip_ranges
    virtual_network_subnet_ids = var.subnet_id != "" ? [var.subnet_id] : []
  }

  tags = var.tags
}

# --- AWS Secrets Manager ---
resource "aws_kms_key" "secrets" {
  count                   = var.cloud_provider == "aws" && var.enable_key_vault ? 1 : 0
  description             = "KMS key for ${local.resource_prefix} secrets"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "secrets" {
  count         = var.cloud_provider == "aws" && var.enable_key_vault ? 1 : 0
  name          = "alias/${local.resource_prefix}-secrets"
  target_key_id = aws_kms_key.secrets[0].key_id
}

# --- GCP Secret Manager ---
resource "google_project_service" "secretmanager" {
  count   = var.cloud_provider == "gcp" && var.enable_key_vault ? 1 : 0
  service = "secretmanager.googleapis.com"
}
