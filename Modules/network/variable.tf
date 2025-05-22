variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrsubnet(var.vpc_cidr, 8, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to create a single NAT Gateway"
  type        = bool
  default     = false

}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "create_db_subnet_group" {
  description = "Whether to create a DB subnet group"
  type        = bool
  default     = false
}

variable "secure_subnets_cidr" {
  description = "List of CIDR blocks for secure subnets"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags that will be add to all resources"
  type        = map(string)
  default = {
    "module" = "network"
  }
}
variable "subnet_tags" {
  description = "Tags that will be add to subnets"
  type        = map(string)
  default = {
    type = "subnet"
  }
}