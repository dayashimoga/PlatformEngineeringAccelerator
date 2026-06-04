output "secret_store_uri" {
  description = "Secret store URI"
  value = coalesce(
    try(azurerm_key_vault.main[0].vault_uri, ""),
    try(aws_kms_key.secrets[0].arn, ""),
    "none"
  )
  sensitive = true
}

output "secret_store_id" {
  description = "Secret store resource ID"
  value = coalesce(
    try(azurerm_key_vault.main[0].id, ""),
    try(aws_kms_key.secrets[0].arn, ""),
    "none"
  )
}
