variable "db_family" {
  description = "The family of the DB parameter group. For example, mysql8.0"
  type        = string
}
variable "db_engine" {
  description = "The database engine to use"
  type        = string
}

variable "environment" {
  description = "The environment for the database"
  type        = string
}

variable "db_username" {
  description = "The username for the database instance"
  type        = string
}
variable "db_password" {
  description = "The password for the database instance"
  type        = string
  sensitive   = true
}
variable "db_subnet_group" {
  description = "The name of the DB subnet group"
  type        = string
}
variable "multi_az" {
  description = "Whether to create a multi-AZ database instance"
  type        = bool
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "allowed_cidr" {
  description = "The CIDR blocks that are allowed to access the database"
  type        = string
}
variable "allowed_sg" {
  description = "The security group that is allowed to access the database"
  type        = string
}

variable "tags" {
  description = "Tags that will be add to all resources"
  type        = map(string)
  default = {
    "module" = "database"
  }
}
