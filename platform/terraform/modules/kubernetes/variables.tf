variable "project_name" { type = string }
variable "environment" { type = string }
variable "cloud_provider" { type = string }
variable "region" { type = string }
variable "kubernetes_version" { type = string }
variable "node_pool_config" {
  type = object({
    name         = string
    node_count   = number
    min_count    = number
    max_count    = number
    vm_size      = string
    disk_size_gb = number
    max_pods     = number
  })
}
variable "enable_private_cluster" { type = bool; default = false }
variable "subnet_id" { type = string }
variable "vnet_id" { type = string }
variable "allowed_ip_ranges" { type = list(string); default = [] }
variable "tags" { type = map(string); default = {} }
