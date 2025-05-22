provider "aws" {
  region = var.region
}

data "aws_availability_zones" "availablility_zones" {
  state = "available"
}

module "vpc" {
  source = "./Modules/network"

  vpc_name               = var.vpc_name
  vpc_cidr               = var.vpc_cidr
  environment            = var.environment
  create_igw             = true
  public_subnets_cidr    = var.public_subnets_cidrs
  private_subnets_cidr   = var.private_subnets_cidrs
  availability_zones     = data.aws_availability_zones.availablility_zones.names
  create_nat_gateway     = true
  single_nat_gateway     = false
  create_db_subnet_group = true
  secure_subnets_cidr    = var.secure_subnets_cidrs
}

module "servers" {
  source = "./Modules/servers"

  amazon_or_ubuntu               = "amazon"
  environment                    = var.environment
  create_key_pair                = true
  public_key_path                = "~/.ssh/id_rsa.pub"
  create_public_instance         = true
  public_instance_type           = "t2.micro"
  public_subnet_id               = module.vpc.public_subnet_ids
  add_public_instance_user_data  = false
  create_private_instance        = true
  private_instance_type          = "t2.micro"
  private_subnet_id              = module.vpc.private_subnet_ids
  add_private_instance_user_data = false
  single_lb                      = false
  availability_zone              = data.aws_availability_zones.availablility_zones.names
  vpc_id                         = module.vpc.vpc_id
  my_public_ip                   = var.my_public_ip

  tags = {
    ConfigureBy = "ansible"
  }
}

module "database" {
  source = "./Modules/database"

  db_family       = var.db_family
  db_engine       = var.db_engine
  environment     = var.environment
  db_username     = var.db_username
  db_password     = var.db_password
  db_subnet_group = module.vpc.db_subnet_group_name
  multi_az        = false
  vpc_id          = module.vpc.vpc_id
  allowed_cidr    = var.vpc_cidr
  allowed_sg      = module.servers.private_instance_sg_id
}
