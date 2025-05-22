# In This File the Script which create VPC, Internet Gateway, NAT Gateway, and thier dependencies

# locals
locals {
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
    ManagedBy   = "Terraform"
  }
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, var.tags, {
    Name = var.vpc_name
  })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-igw"
  })
}

# NAT Gateway
locals {
  number_nat_gateways = var.single_nat_gateway ? 1 : 2
}

resource "aws_subnet" "nat_subnet" {
  count                   = var.create_igw && var.create_nat_gateway ? local.number_nat_gateways : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 254 - count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-nat-subnet-${count.index + 1}"
  })
}
resource "aws_route_table_association" "nat_rt_association" {
  count          = var.create_igw && var.create_nat_gateway ? local.number_nat_gateways : 0
  subnet_id      = aws_subnet.nat_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}

resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? local.number_nat_gateways : 0

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway ? local.number_nat_gateways : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.nat_subnet[count.index].id

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
  })
}
