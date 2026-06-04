# =============================================================================
# Storage Module — Multi-Cloud Storage
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  # Storage account names must be lowercase alphanumeric, 3-24 chars
  storage_name    = replace(lower("st${var.project_name}${var.environment}"), "-", "")
}

# --- Azure Storage ---
resource "azurerm_resource_group" "storage" {
  count    = var.cloud_provider == "azure" ? 1 : 0
  name     = "rg-${local.resource_prefix}-storage"
  location = var.region
  tags     = var.tags
}

resource "azurerm_storage_account" "main" {
  count                    = var.cloud_provider == "azure" ? 1 : 0
  name                     = substr(local.storage_name, 0, 24)
  resource_group_name      = azurerm_resource_group.storage[0].name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = var.tags
}

# --- AWS S3 ---
resource "aws_s3_bucket" "main" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = "${local.resource_prefix}-storage"
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "main" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = aws_s3_bucket.main[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = aws_s3_bucket.main[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  count                   = var.cloud_provider == "aws" ? 1 : 0
  bucket                  = aws_s3_bucket.main[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- GCP Storage ---
resource "google_storage_bucket" "main" {
  count                       = var.cloud_provider == "gcp" ? 1 : 0
  name                        = "${local.resource_prefix}-storage"
  location                    = var.region
  force_destroy               = var.environment != "prod"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}
