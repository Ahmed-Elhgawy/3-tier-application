# In This File the Script which create NACLs, and thier dependencies

# NACLs for Public Subnets
resource "aws_network_acl" "public_nacls" {
  vpc_id = aws_vpc.vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-public-nacl"
  })
}
resource "aws_network_acl_association" "public_nacl_association" {
  for_each = {
    for k, v in aws_subnet.public_subnets :
    k => v
  }
  network_acl_id = aws_network_acl.public_nacls.id
  subnet_id      = each.value.id
}

# NACLs for Private Subnets
resource "aws_network_acl" "private_nacls" {
  vpc_id = aws_vpc.vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-private-nacl"
  })
}
resource "aws_network_acl_rule" "private_ingress_ssh" {
  network_acl_id = aws_network_acl.private_nacls.id
  rule_number    = 150
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 22
  to_port        = 22
}
resource "aws_network_acl_rule" "private_egress_ssh" {
  network_acl_id = aws_network_acl.private_nacls.id
  rule_number    = 150
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 22
  to_port        = 22
}
resource "aws_network_acl_association" "private_nacl_association" {
  for_each = {
    for k, v in aws_subnet.private_subnets :
    k => v
  }
  network_acl_id = aws_network_acl.private_nacls.id
  subnet_id      = each.value.id
}

# NACLs for Secure Subnets
resource "aws_network_acl" "secure_nacls" {
  count  = var.create_db_subnet_group ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, var.tags, {
    Name = "${var.vpc_name}-secure-nacl"
  })
}
resource "aws_network_acl_rule" "secure_ingress_ssh" {
  count          = var.create_db_subnet_group ? length(var.secure_subnets_cidr) : 0
  network_acl_id = aws_network_acl.secure_nacls[0].id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.secure_subnets_cidr[count.index]
  from_port      = 22
  to_port        = 22
}
resource "aws_network_acl_rule" "secure_egress_ssh" {
  count          = var.create_db_subnet_group ? length(var.secure_subnets_cidr) : 0
  network_acl_id = aws_network_acl.secure_nacls[0].id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.secure_subnets_cidr[count.index]
  from_port      = 22
  to_port        = 22
}
resource "aws_network_acl_rule" "secure_ingress_db" {
  count          = var.create_db_subnet_group ? length(var.secure_subnets_cidr) : 0
  network_acl_id = aws_network_acl.secure_nacls[0].id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.secure_subnets_cidr[count.index]
  from_port      = 5432
  to_port        = 5432
}
resource "aws_network_acl_rule" "secure_egress_db" {
  count          = var.create_db_subnet_group ? length(var.secure_subnets_cidr) : 0
  network_acl_id = aws_network_acl.secure_nacls[0].id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.secure_subnets_cidr[count.index]
  from_port      = 5432
  to_port        = 5432
}
resource "aws_network_acl_association" "secure_nacl_association" {
  count          = length(var.secure_subnets_cidr)
  network_acl_id = aws_network_acl.secure_nacls[0].id
  subnet_id      = aws_subnet.secure_subnets[count.index].id
}
