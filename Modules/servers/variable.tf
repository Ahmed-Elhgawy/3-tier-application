variable "amazon_or_ubuntu" {
  description = "Choose between Amazon Linux or Ubuntu"
  type        = string
  default     = "amazon"
  validation {
    condition     = contains(["amazon", "ubuntu"], var.amazon_or_ubuntu)
    error_message = "The value must be either 'amazon' or 'ubuntu'."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "create_key_pair" {
  description = "Create a key pair for SSH access"
  type        = bool
}
variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  sensitive   = true
}

variable "create_public_instance" {
  description = "Create a public instance"
  type        = bool
}
variable "public_instance_type" {
  description = "Type of instance to create"
  type        = string
}
variable "public_subnet_id" {
  description = "Public subnet ID where the instance will be launched"
  type        = list(string)
}
variable "add_public_instance_user_data" {
  description = "Add user data to the instance"
  type        = bool
  default     = false
}
variable "public_instance_user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = ""
}

variable "create_private_instance" {
  description = "Create a private instance"
  type        = bool
}
variable "private_instance_type" {
  description = "Type of instance to create"
  type        = string
}
variable "private_subnet_id" {
  description = "Private subnet ID where the instance will be launched"
  type        = list(string)
}
variable "add_private_instance_user_data" {
  description = "Add user data to the instance"
  type        = bool
  default     = false
}
variable "private_instance_user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = ""
}

variable "single_lb" {
  description = "Whether to create a single LB"
  type        = bool
}
variable "availability_zone" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the instances will be launched"
  type        = string
}

variable "my_public_ip" {
  description = "Public IP address of the computer"
  type        = string
}

variable "tags" {
  description = "Tags that will be add to all resources"
  type        = map(string)
  default = {
    "module" = "servers"
  }
}
