# In This File the script which get the AMI ID from the AWS account and region is defined

# locals
locals {
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
    ManagedBy   = "Terraform"
  }
}

# Amazon linux 2 AMI ID
data "aws_ami" "amanzon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Ubuntu AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# This is the local variable which will be used to get the AMI ID
locals {
  amazon_linux = data.aws_ami.amanzon_linux.id
  ubuntu       = data.aws_ami.ubuntu.id
}
