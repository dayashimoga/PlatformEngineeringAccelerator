# Dev Environment
project_name    = "platform-accelerator"
environment     = "dev"
cloud_provider  = "azure"
region          = "eastus2"

kubernetes_version = "1.29"
node_pool_config = {
  name         = "system"
  node_count   = 2
  min_count    = 1
  max_count    = 5
  vm_size      = "Standard_D2s_v5"
  disk_size_gb = 64
  max_pods     = 110
}

enable_private_cluster   = false
enable_monitoring        = true
enable_workload_identity = true
enable_key_vault         = true
log_retention_days       = 14

tags = {
  ManagedBy  = "terraform"
  Platform   = "platform-accelerator"
  CostCenter = "engineering"
}
