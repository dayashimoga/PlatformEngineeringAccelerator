variable "project_name" { type = string }
variable "environment" { type = string }
variable "cloud_provider" { type = string }
variable "region" { type = string }
variable "enable_monitoring" { type = bool; default = true }
variable "log_retention_days" { type = number; default = 30 }
variable "kubernetes_cluster_id" { type = string; default = "" }
variable "tags" { type = map(string); default = {} }
