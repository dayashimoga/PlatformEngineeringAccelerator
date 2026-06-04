# =============================================================================
# Networking Module — Multi-Cloud VPC/VNet
# =============================================================================

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# Azure Networking
# =============================================================================
resource "azurerm_resource_group" "networking" {
  count    = var.cloud_provider == "azure" ? 1 : 0
  name     = "rg-${local.resource_prefix}-networking"
  location = var.region
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  count               = var.cloud_provider == "azure" ? 1 : 0
  name                = "vnet-${local.resource_prefix}"
  address_space       = [var.vnet_cidr]
  location            = var.region
  resource_group_name = azurerm_resource_group.networking[0].name
  tags                = var.tags
}

resource "azurerm_subnet" "public" {
  count                = var.cloud_provider == "azure" ? 1 : 0
  name                 = "snet-${local.resource_prefix}-public"
  resource_group_name  = azurerm_resource_group.networking[0].name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.subnet_cidrs.public]
}

resource "azurerm_subnet" "private" {
  count                = var.cloud_provider == "azure" ? 1 : 0
  name                 = "snet-${local.resource_prefix}-private"
  resource_group_name  = azurerm_resource_group.networking[0].name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.subnet_cidrs.private]
}

resource "azurerm_subnet" "data" {
  count                = var.cloud_provider == "azure" ? 1 : 0
  name                 = "snet-${local.resource_prefix}-data"
  resource_group_name  = azurerm_resource_group.networking[0].name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.subnet_cidrs.data]
}

resource "azurerm_nat_gateway" "main" {
  count               = var.cloud_provider == "azure" ? 1 : 0
  name                = "natgw-${local.resource_prefix}"
  location            = var.region
  resource_group_name = azurerm_resource_group.networking[0].name
  sku_name            = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "nat" {
  count               = var.cloud_provider == "azure" ? 1 : 0
  name                = "pip-${local.resource_prefix}-nat"
  location            = var.region
  resource_group_name = azurerm_resource_group.networking[0].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  count                = var.cloud_provider == "azure" ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.main[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  count          = var.cloud_provider == "azure" ? 1 : 0
  subnet_id      = azurerm_subnet.private[0].id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

resource "azurerm_network_security_group" "private" {
  count               = var.cloud_provider == "azure" ? 1 : 0
  name                = "nsg-${local.resource_prefix}-private"
  location            = var.region
  resource_group_name = azurerm_resource_group.networking[0].name
  tags                = var.tags

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

# =============================================================================
# AWS Networking
# =============================================================================
resource "aws_vpc" "main" {
  count                = var.cloud_provider == "aws" ? 1 : 0
  cidr_block           = var.vnet_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "vpc-${local.resource_prefix}"
  })
}

resource "aws_subnet" "public" {
  count                   = var.cloud_provider == "aws" ? 1 : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = var.subnet_cidrs.public
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                     = "subnet-${local.resource_prefix}-public"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "private" {
  count             = var.cloud_provider == "aws" ? 1 : 0
  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.subnet_cidrs.private
  availability_zone = "${var.region}a"

  tags = merge(var.tags, {
    Name                              = "subnet-${local.resource_prefix}-private"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_subnet" "data" {
  count             = var.cloud_provider == "aws" ? 1 : 0
  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.subnet_cidrs.data
  availability_zone = "${var.region}b"

  tags = merge(var.tags, {
    Name = "subnet-${local.resource_prefix}-data"
  })
}

resource "aws_internet_gateway" "main" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = merge(var.tags, {
    Name = "igw-${local.resource_prefix}"
  })
}

resource "aws_eip" "nat" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "eip-${local.resource_prefix}-nat"
  })
}

resource "aws_nat_gateway" "main" {
  count         = var.cloud_provider == "aws" ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "natgw-${local.resource_prefix}"
  })
}

# =============================================================================
# GCP Networking
# =============================================================================
resource "google_compute_network" "main" {
  count                   = var.cloud_provider == "gcp" ? 1 : 0
  name                    = "vpc-${local.resource_prefix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  count         = var.cloud_provider == "gcp" ? 1 : 0
  name          = "subnet-${local.resource_prefix}-private"
  ip_cidr_range = var.subnet_cidrs.private
  region        = var.region
  network       = google_compute_network.main[0].id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

resource "google_compute_router" "main" {
  count   = var.cloud_provider == "gcp" ? 1 : 0
  name    = "router-${local.resource_prefix}"
  region  = var.region
  network = google_compute_network.main[0].id
}

resource "google_compute_router_nat" "main" {
  count                              = var.cloud_provider == "gcp" ? 1 : 0
  name                               = "nat-${local.resource_prefix}"
  router                             = google_compute_router.main[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
