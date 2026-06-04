# Production Environment
project_name    = "platform-accelerator"
environment     = "prod"
cloud_provider  = "azure"
region          = "eastus2"

kubernetes_version = "1.29"
node_pool_config = {
  name         = "system"
  node_count   = 3
  min_count    = 3
  max_count    = 20
  vm_size      = "Standard_D4s_v5"
  disk_size_gb = 128
  max_pods     = 110
}

enable_private_cluster   = true
enable_monitoring        = true
enable_workload_identity = true
enable_key_vault         = true
log_retention_days       = 90

tags = {
  ManagedBy  = "terraform"
  Platform   = "platform-accelerator"
  CostCenter = "engineering"
  Compliance = "required"
}
