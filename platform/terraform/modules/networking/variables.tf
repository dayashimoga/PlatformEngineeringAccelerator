variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider (azure, aws, gcp)"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for VNet/VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "Subnet CIDR blocks"
  type = object({
    public  = string
    private = string
    data    = string
  })
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
