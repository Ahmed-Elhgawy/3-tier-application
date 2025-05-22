# In This File the Script which create Subnets(Public, Private, Secure)

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, var.tags, var.subnet_tags, {
    Name   = "${var.vpc_name}-public-${count.index + 1}"
    Public = "true"
  })
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets_cidr[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, var.tags, var.subnet_tags, {
    Name   = "${var.vpc_name}-private-${count.index + 1}"
    Public = "false"
  })
}

# Secure Private Subnets for DB
resource "aws_subnet" "secure_subnets" {
  count                   = var.create_db_subnet_group ? length(var.secure_subnets_cidr) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.secure_subnets_cidr[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, var.tags, var.subnet_tags, {
    Name   = "${var.vpc_name}-secure-${count.index + 1}"
    Public = "false"
  })
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  count       = var.create_db_subnet_group ? 1 : 0
  name        = "${var.vpc_name}-db-subnet-group"
  description = "DB Subnet Group for ${var.vpc_name}"
  subnet_ids  = aws_subnet.secure_subnets[*].id

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-db-subnet-group"
  })
}
