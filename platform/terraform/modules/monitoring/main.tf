# =============================================================================
# Monitoring Module — Log Analytics / CloudWatch / Cloud Logging
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

# --- Azure Monitor ---
resource "azurerm_resource_group" "monitoring" {
  count    = var.cloud_provider == "azure" && var.enable_monitoring ? 1 : 0
  name     = "rg-${local.resource_prefix}-monitoring"
  location = var.region
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  count               = var.cloud_provider == "azure" && var.enable_monitoring ? 1 : 0
  name                = "law-${local.resource_prefix}"
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring[0].name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

resource "azurerm_monitor_workspace" "prometheus" {
  count               = var.cloud_provider == "azure" && var.enable_monitoring ? 1 : 0
  name                = "prometheus-${local.resource_prefix}"
  resource_group_name = azurerm_resource_group.monitoring[0].name
  location            = var.region
  tags                = var.tags
}

resource "azurerm_dashboard_grafana" "main" {
  count                             = var.cloud_provider == "azure" && var.enable_monitoring ? 1 : 0
  name                              = "grafana-${local.resource_prefix}"
  resource_group_name               = azurerm_resource_group.monitoring[0].name
  location                          = var.region
  grafana_major_version             = 10
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.prometheus[0].id
  }

  tags = var.tags
}

# --- AWS CloudWatch ---
resource "aws_cloudwatch_log_group" "main" {
  count             = var.cloud_provider == "aws" && var.enable_monitoring ? 1 : 0
  name              = "/platform/${local.resource_prefix}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_prometheus_workspace" "main" {
  count = var.cloud_provider == "aws" && var.enable_monitoring ? 1 : 0
  alias = "prometheus-${local.resource_prefix}"
  tags  = var.tags
}

resource "aws_grafana_workspace" "main" {
  count                    = var.cloud_provider == "aws" && var.enable_monitoring ? 1 : 0
  name                     = "grafana-${local.resource_prefix}"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.grafana[0].arn

  data_sources = ["PROMETHEUS", "CLOUDWATCH"]

  tags = var.tags
}

resource "aws_iam_role" "grafana" {
  count = var.cloud_provider == "aws" && var.enable_monitoring ? 1 : 0
  name  = "role-${local.resource_prefix}-grafana"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "grafana.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# --- GCP Cloud Monitoring ---
resource "google_monitoring_notification_channel" "email" {
  count        = var.cloud_provider == "gcp" && var.enable_monitoring ? 1 : 0
  display_name = "Platform Team Email"
  type         = "email"
  labels = {
    email_address = "platform-team@your-org.com"
  }
}
