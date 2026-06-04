output "cluster_name" {
  description = "Kubernetes cluster name"
  value = coalesce(
    try(azurerm_kubernetes_cluster.main[0].name, ""),
    try(aws_eks_cluster.main[0].name, ""),
    try(google_container_cluster.main[0].name, ""),
    "none"
  )
}

output "cluster_id" {
  description = "Kubernetes cluster ID"
  value = coalesce(
    try(azurerm_kubernetes_cluster.main[0].id, ""),
    try(aws_eks_cluster.main[0].arn, ""),
    try(google_container_cluster.main[0].id, ""),
    "none"
  )
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value = coalesce(
    try(azurerm_kubernetes_cluster.main[0].kube_config[0].host, ""),
    try(aws_eks_cluster.main[0].endpoint, ""),
    try("https://${google_container_cluster.main[0].endpoint}", ""),
    "none"
  )
  sensitive = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate (base64)"
  value = coalesce(
    try(azurerm_kubernetes_cluster.main[0].kube_config[0].cluster_ca_certificate, ""),
    try(aws_eks_cluster.main[0].certificate_authority[0].data, ""),
    try(google_container_cluster.main[0].master_auth[0].cluster_ca_certificate, ""),
    "none"
  )
  sensitive = true
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value = coalesce(
    try(azurerm_kubernetes_cluster.main[0].oidc_issuer_url, ""),
    try(aws_eks_cluster.main[0].identity[0].oidc[0].issuer, ""),
    "none"
  )
}

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value = var.cloud_provider == "azure" ? "az aks get-credentials --resource-group rg-${var.project_name}-${var.environment}-aks --name aks-${var.project_name}-${var.environment}" : (
    var.cloud_provider == "aws" ? "aws eks update-kubeconfig --name eks-${var.project_name}-${var.environment} --region ${var.region}" : (
      "gcloud container clusters get-credentials gke-${var.project_name}-${var.environment} --region ${var.region}"
    )
  )
}
