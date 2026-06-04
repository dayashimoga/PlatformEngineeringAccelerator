# =============================================================================
# Outputs — Platform Infrastructure
# =============================================================================

# --- Networking ---
output "vnet_id" {
  description = "Virtual network ID"
  value       = module.networking.vnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.networking.private_subnet_id
}

# --- Kubernetes ---
output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = module.kubernetes.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes cluster API endpoint"
  value       = module.kubernetes.cluster_endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = module.kubernetes.cluster_ca_certificate
  sensitive   = true
}

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = module.kubernetes.kubeconfig_command
}

# --- Identity ---
output "workload_identity_client_id" {
  description = "Workload identity client ID"
  value       = module.identity.workload_identity_client_id
}

# --- Storage ---
output "storage_account_name" {
  description = "Storage account/bucket name"
  value       = module.storage.storage_name
}

# --- Security ---
output "key_vault_uri" {
  description = "Key Vault / Secrets Manager URI"
  value       = module.security.secret_store_uri
  sensitive   = true
}

# --- Monitoring ---
output "monitoring_workspace_id" {
  description = "Monitoring workspace ID"
  value       = module.monitoring.workspace_id
}

output "grafana_endpoint" {
  description = "Grafana endpoint URL"
  value       = module.monitoring.grafana_endpoint
}
