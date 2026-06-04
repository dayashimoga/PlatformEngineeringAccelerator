# =============================================================================
# Providers Configuration
# =============================================================================

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  skip_provider_registration = true
}

provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

provider "google" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.kubernetes.cluster_endpoint
  cluster_ca_certificate = base64decode(module.kubernetes.cluster_ca_certificate)

  # Azure AKS
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = var.cloud_provider == "azure" ? "kubelogin" : (var.cloud_provider == "aws" ? "aws" : "gke-gcloud-auth-plugin")
    args = var.cloud_provider == "azure" ? [
      "get-token",
      "--login", "azurecli",
      "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630"
    ] : (var.cloud_provider == "aws" ? [
      "eks", "get-token",
      "--cluster-name", module.kubernetes.cluster_name,
      "--region", var.region
    ] : [])
  }
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes.cluster_endpoint
    cluster_ca_certificate = base64decode(module.kubernetes.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = var.cloud_provider == "azure" ? "kubelogin" : (var.cloud_provider == "aws" ? "aws" : "gke-gcloud-auth-plugin")
      args = var.cloud_provider == "azure" ? [
        "get-token",
        "--login", "azurecli",
        "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630"
      ] : (var.cloud_provider == "aws" ? [
        "eks", "get-token",
        "--cluster-name", module.kubernetes.cluster_name,
        "--region", var.region
      ] : [])
    }
  }
}
