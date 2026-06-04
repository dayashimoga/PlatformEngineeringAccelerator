variable "project_name" { type = string }
variable "environment" { type = string }
variable "cloud_provider" { type = string }
variable "region" { type = string }
variable "kubernetes_cluster_name" { type = string }
variable "kubernetes_oidc_issuer" { type = string }
variable "enable_workload_identity" { type = bool; default = true }
variable "tags" { type = map(string); default = {} }
