# In This File the script which creates the security groups for database instance
resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "Security group for the database instance"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, var.tags, {
    Name = "db-security-group"
  })
}
resource "aws_vpc_security_group_ingress_rule" "db_allow_postgres_allow_postgres" {
  security_group_id            = aws_security_group.db_security_group.id
  cidr_ipv4                    = var.allowed_cidr
  referenced_security_group_id = var.allowed_sg
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}
resource "aws_vpc_security_group_ingress_rule" "db_allow_postgres_allow_ssh" {
  security_group_id            = aws_security_group.db_security_group.id
  cidr_ipv4                    = var.allowed_cidr
  referenced_security_group_id = var.allowed_sg
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
