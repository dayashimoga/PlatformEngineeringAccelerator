# =============================================================================
# Backend Configuration — Remote State with Locking
# =============================================================================
# Supports Azure Blob Storage, AWS S3, or GCS backends.
# Configure the appropriate backend based on your cloud provider.
# =============================================================================

# --- Azure Backend (default) ---
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-platform-tfstate"
    storage_account_name = "stplatformtfstate"
    container_name       = "tfstate"
    key                  = "platform.terraform.tfstate"
    use_oidc             = true
  }
}

# --- AWS Backend (uncomment to use) ---
# terraform {
#   backend "s3" {
#     bucket         = "platform-terraform-state"
#     key            = "platform/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "platform-terraform-locks"
#     encrypt        = true
#   }
# }

# --- GCS Backend (uncomment to use) ---
# terraform {
#   backend "gcs" {
#     bucket = "platform-terraform-state"
#     prefix = "platform/state"
#   }
# }
