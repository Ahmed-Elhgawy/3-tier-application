# In This File the script which creates Security Group, and its dependency

# Application Load Balancer Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, var.tags, {
    Name = "alb_security_group"
  })
}
resource "aws_vpc_security_group_ingress_rule" "alb_allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "alb_allow_all" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Network Load Balancer Security Group
resource "aws_security_group" "nlb_sg" {
  name        = "nlb_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, var.tags, {
    Name = "nlb_security_group"
  })
}
resource "aws_vpc_security_group_ingress_rule" "nlb_allow_port_3000" {
  security_group_id            = aws_security_group.nlb_sg.id
  referenced_security_group_id = aws_security_group.public_instance_sg.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
}
resource "aws_vpc_security_group_egress_rule" "nlb_allow_all" {
  security_group_id = aws_security_group.nlb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Public Instance Security Group
resource "aws_security_group" "public_instance_sg" {
  name        = "public_instance_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, var.tags, {
    Name = "public_instance_security_group"
  })
}
resource "aws_vpc_security_group_ingress_rule" "pi_allow_port_3000" {
  security_group_id            = aws_security_group.public_instance_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
}
resource "aws_vpc_security_group_ingress_rule" "pi_allow_ssh" {
  security_group_id = aws_security_group.public_instance_sg.id
  cidr_ipv4         = var.my_public_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "pi_allow_all" {
  security_group_id = aws_security_group.public_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Private Instance Security Group
resource "aws_security_group" "private_instance_sg" {
  name        = "private_instance_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, var.tags, {
    Name = "private_instance_security_group"
  })
}
resource "aws_vpc_security_group_ingress_rule" "pri_allow_port_3000" {
  security_group_id            = aws_security_group.private_instance_sg.id
  referenced_security_group_id = aws_security_group.nlb_sg.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
}
resource "aws_vpc_security_group_ingress_rule" "pri_allow_ssh" {
  security_group_id            = aws_security_group.private_instance_sg.id
  referenced_security_group_id = aws_security_group.public_instance_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_egress_rule" "pri_allow_all" {
  security_group_id = aws_security_group.private_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
