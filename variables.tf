variable "region" {
  type = string
  validation {
    condition     = contains(["us-east-1", "us-west-2"], var.region)
    error_message = "Region must be one of: us-east-1, us-west-2."
  }
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "values for the VPC CIDR block."
  type        = string
  validation {
    condition     = can(cidrsubnet(var.vpc_cidr, 8, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnets_cidrs" {
  description = "values for the public subnets CIDR blocks."
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "values for the private subnets CIDR blocks."
  type        = list(string)
}

variable "secure_subnets_cidrs" {
  description = "values for the secure subnets CIDR blocks."
  type        = list(string)
}

variable "my_public_ip" {
  description = "Public IP address of the user."
  type        = string
  sensitive   = true
}

variable "db_family" {
  description = "The family of the DB parameter group. For example, mysql8.0"
  type        = string
}
variable "db_engine" {
  description = "The database engine to use"
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

variable "environment" {
  description = "The environment for the database"
  type        = string
}