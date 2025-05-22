# In This File the Script which create Route Tables, and thier dependencies

# Public Route Table
resource "aws_route_table" "public_route_table" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-public-rt"
  })
}
resource "aws_route_table_association" "public_rt_association" {
  count          = var.create_igw ? length(var.public_subnets_cidr) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[0].id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[1].id
  }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-private-rt"
  })
}
resource "aws_route_table_association" "private_rt_association" {
  count          = var.create_nat_gateway ? length(var.private_subnets_cidr) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}

# Secure Route Table
resource "aws_route_table" "secure_route_table" {
  count  = var.create_db_subnet_group ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-secure-rt"
  })
}
resource "aws_route_table_association" "secure_rt_association" {
  count          = var.create_db_subnet_group ? length(var.secure_subnets_cidr) : 0
  subnet_id      = aws_subnet.secure_subnets[count.index].id
  route_table_id = aws_route_table.secure_route_table[0].id
}

# Default Route Table
resource "aws_default_route_table" "vpc_default_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-default-rt"
  })
}
resource "aws_route_table_association" "default_public_rt_association" {
  count          = !var.create_igw && length(var.public_subnets_cidr) != 0 ? length(var.public_subnets_cidr) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_default_route_table.vpc_default_rt.id
}
resource "aws_route_table_association" "default_private_rt_association" {
  count          = !var.create_igw && length(var.private_subnets_cidr) != 0 ? length(var.public_subnets_cidr) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_default_route_table.vpc_default_rt.id
}
