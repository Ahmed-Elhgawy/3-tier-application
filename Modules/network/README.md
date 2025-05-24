# Network Module

This Terraform module provisions a complete VPC network architecture in AWS with support for public, private, and secure (DB) subnets. It includes configurable options for creating an Internet Gateway, NAT Gateways (single or multi-AZ), DB subnet groups, and Network ACLs.

---

## 🧱 Features

- VPC creation with custom CIDR block and name.
- Multi-AZ support for high availability.
- Public, private, and secure subnet provisioning.
- Optional creation of:
  - Internet Gateway (IGW)
  - NAT Gateway(s) (single or one per AZ)
  - DB subnet group
- Network ACLs for each subnet type.
- Tagged infrastructure for environment management.

---

## 📥 Input Variables

| Name                     | Description                                                         | Type           | Default                  | Required |
|--------------------------|---------------------------------------------------------------------|----------------|--------------------------|:--------:|
| `vpc_cidr`               | The CIDR block for the VPC                                          | `string`       |    —                     | ✅      |
| `vpc_name`               | The name of the VPC                                                 | `string`       |    —                     | ✅      |
| `environment`            | The environment for the VPC (e.g., dev, staging, prod)              | `string`       |    —                     | ✅      |
| `availability_zones`     | List of AZs to use for subnets                                      | `list(string)` |    —                     | ✅      |
| `create_igw`             | Whether to create an Internet Gateway                               | `bool`         | `true`                   | ❌      |
| `public_subnets_cidr`    | List of CIDRs for public subnets                                    | `list(string)` |  `[]`                    | ❌      |
| `private_subnets_cidr`   | List of CIDRs for private subnets                                   | `list(string)` |  `[]`                    | ❌      |
| `secure_subnets_cidr`    | List of CIDRs for secure subnets (e.g., DB)                         | `list(string)` |  `[]`                    | ❌      |
| `create_nat_gateway`     | Whether to create NAT Gateway(s)                                    | `bool`         | `true`                   | ❌      |
| `single_nat_gateway`     | Whether to create a single NAT Gateway (true = 1, false = 1 per AZ) | `bool`         | `false`                  | ❌      |
| `create_db_subnet_group` | Whether to create a DB subnet group                                 | `bool`         | `false`                  | ❌      |
| `tags`                   | Tags to apply to all resources                                      | `map(string)`  | `{ module = "network" }` | ❌      |
| `subnet_tags`            | Tags to apply to subnets                                            | `map(string)`  | `{ type = "subnet" }`    | ❌      |

---

## 📤 Outputs

| Name                                                                | Description                                     |
|---------------------------------------------------------------------|-------------------------------------------------|
| `vpc_id`                                                            | The ID of the created VPC                       |
| `vpc_arn`                                                           | The ARN of the VPC                              |
| `vpc_cidr_block`                                                    | The CIDR block of the VPC                       |
| `igw_id`, `igw_arn`                                                 | Internet Gateway ID and ARN (if created)        |
| `public_subnet_ids`, `subnet_arns`                                  | List of public subnet IDs and ARNs              |
| `private_subnet_ids`, `private_subnet_arns`                         | List of private subnet IDs and ARNs             |
| `secure_subnet_ids`, `secure_subnet_arns`                           | List of secure subnet IDs and ARNs              |
| `public_route_table_ids`                                            | Route table ID for public subnets               |
| `private_route_table_ids`                                           | Route table ID for private subnets (multi-NAT)  |
| `private_route_table_ids_single_nat`                                | Route table ID for private subnets (single NAT) |
| `default_route_table_id`                                            | Default VPC route table ID                      |
| `secure_route_table_ids`                                            | Route table for secure/DB subnets               | 
| `eip_id`, `nat_gateway_id`                                          | NAT Elastic IPs and NAT Gateway IDs             |
| `db_subnet_group_id`, `db_subnet_group_arn`, `db_subnet_group_name` | DB Subnet Group details                         |
| `public_nacl_id`, `public_nacl_arn`                                 | Network ACLs for public subnets                 |
| `private_nacl_id`, `private_nacl_arn`                               | Network ACLs for private subnets                |
| `secure_nacl_id`, `secure_nacl_arn`                                 | Network ACLs for secure subnets                 |

---

## 🏗️ Example Usage

```hcl
module "network" {
  source = "./Modules/network"

  vpc_cidr               = "10.0.0.0/16"
  vpc_name               = "my-vpc"
  environment            = "dev"
  availability_zones     = ["us-east-1a", "us-east-1b"]
  public_subnets_cidr    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr   = ["10.0.3.0/24", "10.0.4.0/24"]
  secure_subnets_cidr    = ["10.0.5.0/24", "10.0.6.0/24"]
  create_db_subnet_group = true

  tags = {
    Project     = "3-tier-app"
    Environment = "dev"
  }
}
```

---

## 🛠️ Notes

- Ensure the number of subnet CIDR blocks matches the number of availability zones.
- NAT Gateway costs can be reduced by setting `single_nat_gateway = true`.

---