# VPC Outputs
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "vpc_arn" {
  value = aws_vpc.vpc.arn
}
output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

#IGW Outputs
output "igw_id" {
  value = var.create_igw ? aws_internet_gateway.igw[0].id : null
}
output "igw_arn" {
  value = var.create_igw ? aws_internet_gateway.igw[0].arn : null
}

# Subnet Outputs
# Public Subnet Outputs
output "public_subnet_ids" {
  value = [for s in aws_subnet.public_subnets : s.id]
}
output "subnet_arns" {
  value = [for s in aws_subnet.public_subnets : s.arn]
}
# Private Subnet Outputs
output "private_subnet_ids" {
  value = [for s in aws_subnet.private_subnets : s.id]
}
output "private_subnet_arns" {
  value = [for s in aws_subnet.private_subnets : s.arn]
}
# Secure Subnet Outputs
output "secure_subnet_ids" {
  value = [for s in aws_subnet.secure_subnets : s.id]
}
output "secure_subnet_arns" {
  value = [for s in aws_subnet.secure_subnets : s.arn]
}

# Route Table Outputs
# Public Route Table Outputs
output "public_route_table_ids" {
  value = var.create_igw ? aws_route_table.public_route_table[0].id : null
}
output "private_route_table_ids" {
  value = var.create_nat_gateway ? aws_route_table.private_route_table[0].id : null
}
output "default_route_table_id" {
  value = aws_default_route_table.vpc_default_rt.id
}
output "secure_route_table_ids" {
  value = var.create_db_subnet_group ? aws_route_table.secure_route_table[0].id : null
}

# NAT Gateway Outputs
output "eip_id" {
  value = var.create_nat_gateway ? [for e in aws_eip.nat_eip : e.id] : null
}
output "nat_gateway_id" {
  value = var.create_nat_gateway ? [for n in aws_nat_gateway.nat_gateway : n.id] : null
}

# DB Subnet Group Outputs
output "db_subnet_group_id" {
  value = var.create_db_subnet_group ? aws_db_subnet_group.db_subnet_group[0].id : null
}
output "db_subnet_group_arn" {
  value = var.create_db_subnet_group ? aws_db_subnet_group.db_subnet_group[0].arn : null
}
output "db_subnet_group_name" {
  value = var.create_db_subnet_group ? aws_db_subnet_group.db_subnet_group[0].name : null
}

# NACLs Outputs
output "public_nacl_id" {
  value = aws_network_acl.public_nacls.id
}
output "public_nacl_arn" {
  value = aws_network_acl.public_nacls.arn
}
output "private_nacl_id" {
  value = aws_network_acl.private_nacls.id
}
output "private_nacl_arn" {
  value = aws_network_acl.private_nacls.arn
}
output "secure_nacl_id" {
  value = var.create_db_subnet_group ? aws_network_acl.secure_nacls[0].id : null
}
output "secure_nacl_arn" {
  value = var.create_db_subnet_group ? aws_network_acl.secure_nacls[0].arn : null
}