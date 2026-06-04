output "vnet_id" {
  description = "Virtual network / VPC ID"
  value = coalesce(
    try(azurerm_virtual_network.main[0].id, ""),
    try(aws_vpc.main[0].id, ""),
    try(google_compute_network.main[0].id, ""),
    "none"
  )
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value = coalesce(
    try(azurerm_subnet.private[0].id, ""),
    try(aws_subnet.private[0].id, ""),
    try(google_compute_subnetwork.private[0].id, ""),
    "none"
  )
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value = coalesce(
    try(azurerm_subnet.public[0].id, ""),
    try(aws_subnet.public[0].id, ""),
    "none"
  )
}
