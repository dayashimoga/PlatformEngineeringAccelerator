# =============================================================================
# Main — Platform Infrastructure Composition
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# --- Networking ---
module "networking" {
  source = "./modules/networking"

  project_name    = var.project_name
  environment     = var.environment
  cloud_provider  = var.cloud_provider
  region          = var.region
  vnet_cidr       = var.vnet_cidr
  subnet_cidrs    = var.subnet_cidrs
  tags            = local.common_tags
}

# --- Kubernetes Cluster ---
module "kubernetes" {
  source = "./modules/kubernetes"

  project_name            = var.project_name
  environment             = var.environment
  cloud_provider          = var.cloud_provider
  region                  = var.region
  kubernetes_version      = var.kubernetes_version
  node_pool_config        = var.node_pool_config
  enable_private_cluster  = var.enable_private_cluster
  subnet_id               = module.networking.private_subnet_id
  vnet_id                 = module.networking.vnet_id
  tags                    = local.common_tags

  depends_on = [module.networking]
}

# --- Identity ---
module "identity" {
  source = "./modules/identity"

  project_name              = var.project_name
  environment               = var.environment
  cloud_provider            = var.cloud_provider
  region                    = var.region
  kubernetes_cluster_name   = module.kubernetes.cluster_name
  kubernetes_oidc_issuer    = module.kubernetes.oidc_issuer_url
  enable_workload_identity  = var.enable_workload_identity
  tags                      = local.common_tags

  depends_on = [module.kubernetes]
}

# --- Storage ---
module "storage" {
  source = "./modules/storage"

  project_name    = var.project_name
  environment     = var.environment
  cloud_provider  = var.cloud_provider
  region          = var.region
  tags            = local.common_tags
}

# --- Security ---
module "security" {
  source = "./modules/security"

  project_name        = var.project_name
  environment         = var.environment
  cloud_provider      = var.cloud_provider
  region              = var.region
  enable_key_vault    = var.enable_key_vault
  allowed_ip_ranges   = var.allowed_ip_ranges
  subnet_id           = module.networking.private_subnet_id
  tags                = local.common_tags

  depends_on = [module.networking]
}

# --- Monitoring ---
module "monitoring" {
  source = "./modules/monitoring"

  project_name        = var.project_name
  environment         = var.environment
  cloud_provider      = var.cloud_provider
  region              = var.region
  enable_monitoring   = var.enable_monitoring
  log_retention_days  = var.log_retention_days
  kubernetes_cluster_id = module.kubernetes.cluster_id
  tags                = local.common_tags

  depends_on = [module.kubernetes]
}
