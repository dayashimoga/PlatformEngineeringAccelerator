# =============================================================================
# Variables — Platform Infrastructure
# =============================================================================

# --- General ---
variable "project_name" {
  description = "Name of the platform project"
  type        = string
  default     = "platform-accelerator"
}

variable "environment" {
  description = "Environment name (dev, qa, uat, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, uat, prod."
  }
}

variable "cloud_provider" {
  description = "Target cloud provider (azure, aws, gcp)"
  type        = string
  default     = "azure"
  validation {
    condition     = contains(["azure", "aws", "gcp"], var.cloud_provider)
    error_message = "Cloud provider must be one of: azure, aws, gcp."
  }
}

variable "region" {
  description = "Primary deployment region"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    ManagedBy   = "terraform"
    Platform    = "platform-accelerator"
    Repository  = "platform-engineering-accelerator"
  }
}

# --- Networking ---
variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type = object({
    public  = string
    private = string
    data    = string
  })
  default = {
    public  = "10.0.1.0/24"
    private = "10.0.2.0/24"
    data    = "10.0.3.0/24"
  }
}

# --- Kubernetes ---
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "node_pool_config" {
  description = "Default node pool configuration"
  type = object({
    name           = string
    node_count     = number
    min_count      = number
    max_count      = number
    vm_size        = string
    disk_size_gb   = number
    max_pods       = number
  })
  default = {
    name           = "system"
    node_count     = 3
    min_count      = 2
    max_count      = 10
    vm_size        = "Standard_D4s_v5"
    disk_size_gb   = 128
    max_pods       = 110
  }
}

variable "enable_private_cluster" {
  description = "Enable private Kubernetes cluster"
  type        = bool
  default     = false
}

# --- Monitoring ---
variable "enable_monitoring" {
  description = "Enable monitoring stack deployment"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 30
}

# --- Identity ---
variable "enable_workload_identity" {
  description = "Enable workload identity for pod authentication"
  type        = bool
  default     = true
}

# --- Security ---
variable "enable_key_vault" {
  description = "Enable secret store (Key Vault / Secrets Manager)"
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "IP ranges allowed to access the cluster API"
  type        = list(string)
  default     = []
}
