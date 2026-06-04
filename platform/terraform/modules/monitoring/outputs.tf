output "workspace_id" {
  description = "Monitoring workspace ID"
  value = coalesce(
    try(azurerm_log_analytics_workspace.main[0].id, ""),
    try(aws_cloudwatch_log_group.main[0].arn, ""),
    "none"
  )
}

output "grafana_endpoint" {
  description = "Grafana endpoint URL"
  value = coalesce(
    try(azurerm_dashboard_grafana.main[0].endpoint, ""),
    try(aws_grafana_workspace.main[0].endpoint, ""),
    "none"
  )
}

output "prometheus_endpoint" {
  description = "Prometheus endpoint"
  value = coalesce(
    try(azurerm_monitor_workspace.prometheus[0].query_endpoint, ""),
    try(aws_prometheus_workspace.main[0].prometheus_endpoint, ""),
    "none"
  )
}
