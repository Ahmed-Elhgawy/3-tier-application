# In This File the script which creates Database Instance, and its dependencies

#locals
locals {
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
    ManagedBy   = "Terraform"
  }
}

data "aws_rds_engine_version" "rds_engine" {
  engine                 = var.db_engine
  latest                 = true
  parameter_group_family = var.db_family
}
resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "db-parameter-group"
  family      = data.aws_rds_engine_version.rds_engine.parameter_group_family
  description = "DB parameter group for db instance"

  tags = merge(local.common_tags, var.tags, {
    Name = "db-parameter-group"
  })
}
resource "aws_db_instance" "db_instance" {
  allocated_storage     = 10
  max_allocated_storage = 20
  storage_type          = "gp2"

  db_name        = "db_instance"
  engine         = data.aws_rds_engine_version.rds_engine.engine
  engine_version = data.aws_rds_engine_version.rds_engine.version

  multi_az               = var.multi_az
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  identifier     = "db-instance"
  instance_class = "db.t3.micro"
  username       = var.db_username
  password       = var.db_password

  db_subnet_group_name = var.db_subnet_group

  parameter_group_name = aws_db_parameter_group.db_parameter_group.name
  skip_final_snapshot  = true

  backup_retention_period    = 7
  monitoring_interval        = 60
  auto_minor_version_upgrade = true

  delete_automated_backups = true
  deletion_protection      = true

  tags = merge(local.common_tags, var.tags, {
    Name = "db-instance"
  })
}