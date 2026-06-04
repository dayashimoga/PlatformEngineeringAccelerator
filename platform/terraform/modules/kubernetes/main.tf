# =============================================================================
# Kubernetes Module — AKS / EKS / GKE
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# Azure Kubernetes Service (AKS)
# =============================================================================
resource "azurerm_resource_group" "aks" {
  count    = var.cloud_provider == "azure" ? 1 : 0
  name     = "rg-${local.resource_prefix}-aks"
  location = var.region
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "main" {
  count               = var.cloud_provider == "azure" ? 1 : 0
  name                = "aks-${local.resource_prefix}"
  location            = var.region
  resource_group_name = azurerm_resource_group.aks[0].name
  dns_prefix          = "aks-${local.resource_prefix}"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = var.node_pool_config.name
    node_count           = var.node_pool_config.node_count
    min_count            = var.node_pool_config.min_count
    max_count            = var.node_pool_config.max_count
    vm_size              = var.node_pool_config.vm_size
    os_disk_size_gb      = var.node_pool_config.disk_size_gb
    max_pods             = var.node_pool_config.max_pods
    vnet_subnet_id       = var.subnet_id
    enable_auto_scaling  = true
    type                 = "VirtualMachineScaleSets"

    node_labels = {
      "nodepool" = "system"
      "env"      = var.environment
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
  }

  dynamic "api_server_access_profile" {
    for_each = var.enable_private_cluster ? [1] : []
    content {
      authorized_ip_ranges = var.allowed_ip_ranges
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = true
    expander                         = "least-waste"
    max_graceful_termination_sec     = 600
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = 0.5
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
}

# =============================================================================
# Amazon Elastic Kubernetes Service (EKS)
# =============================================================================
resource "aws_iam_role" "eks_cluster" {
  count = var.cloud_provider == "aws" ? 1 : 0
  name  = "role-${local.resource_prefix}-eks-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count      = var.cloud_provider == "aws" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster[0].name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
  count      = var.cloud_provider == "aws" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster[0].name
}

resource "aws_eks_cluster" "main" {
  count    = var.cloud_provider == "aws" ? 1 : 0
  name     = "eks-${local.resource_prefix}"
  role_arn = aws_iam_role.eks_cluster[0].arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = [var.subnet_id]
    endpoint_private_access = true
    endpoint_public_access  = !var.enable_private_cluster
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_controller,
  ]
}

resource "aws_iam_role" "eks_nodes" {
  count = var.cloud_provider == "aws" ? 1 : 0
  name  = "role-${local.resource_prefix}-eks-nodes"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  count      = var.cloud_provider == "aws" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes[0].name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  count      = var.cloud_provider == "aws" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes[0].name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  count      = var.cloud_provider == "aws" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes[0].name
}

resource "aws_eks_node_group" "main" {
  count           = var.cloud_provider == "aws" ? 1 : 0
  cluster_name    = aws_eks_cluster.main[0].name
  node_group_name = var.node_pool_config.name
  node_role_arn   = aws_iam_role.eks_nodes[0].arn
  subnet_ids      = [var.subnet_id]
  instance_types  = [var.node_pool_config.vm_size]
  disk_size       = var.node_pool_config.disk_size_gb

  scaling_config {
    desired_size = var.node_pool_config.node_count
    min_size     = var.node_pool_config.min_count
    max_size     = var.node_pool_config.max_count
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    nodepool = "system"
    env      = var.environment
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# =============================================================================
# Google Kubernetes Engine (GKE)
# =============================================================================
resource "google_container_cluster" "main" {
  count    = var.cloud_provider == "gcp" ? 1 : 0
  name     = "gke-${local.resource_prefix}"
  location = var.region

  network    = var.vnet_id
  subnetwork = var.subnet_id

  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = var.kubernetes_version

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  workload_identity_config {
    workload_pool = "${data.google_project.current[0].project_id}.svc.id.goog"
  }

  release_channel {
    channel = var.environment == "prod" ? "STABLE" : "REGULAR"
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_cluster ? [1] : []
    content {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "172.16.0.0/28"
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }
}

data "google_project" "current" {
  count = var.cloud_provider == "gcp" ? 1 : 0
}

resource "google_container_node_pool" "main" {
  count      = var.cloud_provider == "gcp" ? 1 : 0
  name       = var.node_pool_config.name
  cluster    = google_container_cluster.main[0].name
  location   = var.region
  node_count = var.node_pool_config.node_count

  autoscaling {
    min_node_count = var.node_pool_config.min_count
    max_node_count = var.node_pool_config.max_count
  }

  node_config {
    machine_type = var.node_pool_config.vm_size
    disk_size_gb = var.node_pool_config.disk_size_gb

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      nodepool = "system"
      env      = var.environment
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
