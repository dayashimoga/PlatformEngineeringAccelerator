output "storage_name" {
  description = "Storage account/bucket name"
  value = coalesce(
    try(azurerm_storage_account.main[0].name, ""),
    try(aws_s3_bucket.main[0].bucket, ""),
    try(google_storage_bucket.main[0].name, ""),
    "none"
  )
}

output "storage_id" {
  description = "Storage resource ID"
  value = coalesce(
    try(azurerm_storage_account.main[0].id, ""),
    try(aws_s3_bucket.main[0].arn, ""),
    try(google_storage_bucket.main[0].id, ""),
    "none"
  )
}
