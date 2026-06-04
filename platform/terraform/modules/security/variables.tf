variable "project_name" { type = string }
variable "environment" { type = string }
variable "cloud_provider" { type = string }
variable "region" { type = string }
variable "enable_key_vault" { type = bool; default = true }
variable "allowed_ip_ranges" { type = list(string); default = [] }
variable "subnet_id" { type = string; default = "" }
variable "tags" { type = map(string); default = {} }
