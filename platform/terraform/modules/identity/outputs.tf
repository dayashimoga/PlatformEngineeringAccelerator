output "workload_identity_client_id" {
  description = "Workload identity client ID / role ARN / service account email"
  value = coalesce(
    try(azurerm_user_assigned_identity.workload[0].client_id, ""),
    try(aws_iam_role.workload[0].arn, ""),
    try(google_service_account.workload[0].email, ""),
    "none"
  )
}
