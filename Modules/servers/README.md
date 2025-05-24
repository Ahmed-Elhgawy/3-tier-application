# Servers Module

This Terraform module is responsible for provisioning compute resources within an existing VPC. It supports the creation of both public and private EC2 instances, SSH key pair management, user data scripts, and secure access control using Security Groups.

---

## 🧱 Features

- Deploy EC2 instances (Amazon Linux or Ubuntu).
- Optionally create a new SSH key pair.
- Configure and launch public and/or private EC2 instances.
- Attach user data scripts to automate boot-time configuration.
- Automatically restrict SSH access to your public IP.
- Create Application Load Balancer (ALB) or Network Load Balancer (NLB).
- Create associated Security Groups for ALB, NLB, and instances.
- Output key resource attributes for further reference.

---

## 📥 Input Variables

| Name                             | Description                                       | Type           | Default                    | Required |
|----------------------------------|---------------------------------------------------|----------------|----------------------------|:--------:|
| `amazon_or_ubuntu`               | Choose between Amazon Linux or Ubuntu             | `string`       | `"amazon"`                 | ❌      |
| `environment`                    | Environment name (e.g., dev, prod)                | `string`       |      —                     | ✅      |
| `create_key_pair`                | Whether to create an SSH key pair                 | `bool`         |      —                     | ✅      |
| `public_key_path`                | Path to your existing public key file             | `string`       | `"~/.ssh/id_rsa.pub"`      | ❌      |
| `create_public_instance`         | Whether to create a public EC2 instance           | `bool`         |      —                     | ✅      |
| `public_instance_type`           | Instance type for the public EC2 (e.g., t3.micro) | `string`       |      —                     | ✅      |
| `public_subnet_id`               | List of subnet IDs for public instance(s)         | `list(string)` |      —                     | ✅      |
| `add_public_instance_user_data`  | Enable user data on the public instance           | `bool`         | `false`                    | ❌      |
| `public_instance_user_data`      | User data script for the public instance          | `string`       | `""`                       | ❌      |
| `create_private_instance`        | Whether to create a private EC2 instance          | `bool`         |      —                     | ✅      |
| `private_instance_type`          | Instance type for the private EC2                 | `string`       |      —                     | ✅      |
| `private_subnet_id`              | List of subnet IDs for private instance(s)        | `list(string)` |      —                     | ✅      |
| `add_private_instance_user_data` | Enable user data on the private instance          | `bool`         | `false`                    | ❌      |
| `private_instance_user_data`     | User data script for the private instance         | `string`       | `""`                       | ❌      |
| `single_lb`                      | Whether to implement a single load balancer logic | `bool`         |      —                     | ✅      |
| `availability_zone`              | List of availability zones                        | `list(string)` |      —                     | ✅      |
| `vpc_id`                         | The ID of the VPC to launch instances into        | `string`       |      —                     | ✅      |
| `my_public_ip`                   | Your public IP address for secure SSH access      | `string`       |      —                     | ✅      |
| `tags`                           | Common tags applied to all resources              | `map(string)`  | `{ "module" = "servers" }` | ❌      |

---

## 📤 Outputs

### 🖥️ Public Instances
| Name                         | Description                              |
|------------------------------|------------------------------------------|
| `public_instance_ids`        | List of public instance IDs              |
| `public_instance_arns`       | List of public instance ARNs             |
| `public_instance_public_dns` | List of public instance public DNS names |
| `public_instance_private_ip` | List of public instance private IPs      |

### 🔐 Private Instances
| Name                          | Description                          |
|-------------------------------|--------------------------------------|
| `private_instance_ids`        | List of private instance IDs         |
| `private_instance_arns`       | List of private instance ARNs        |
| `private_instance_private_ip` | List of private instance private IPs |

### 📡 Application Load Balancer (ALB)
| Name                   | Description              |
|------------------------|--------------------------|
| `alb_dns_name`         | ALB DNS name             |
| `alb_arn`              | ALB ARN                  |
| `alb_target_group_id`  | Target group ID for ALB  |
| `alb_target_group_arn` | Target group ARN for ALB |
| `alb_listener_id`      | ALB listener ID          |
| `alb_listener_arn`     | ALB listener ARN         |

### ⚙️ Network Load Balancer (NLB)
| Name                   | Description              |
|------------------------|--------------------------|
| `nlb_dns_name`         | NLB DNS name             |
| `nlb_arn`              | NLB ARN                  |
| `nlb_target_group_id`  | Target group ID for NLB  |
| `nlb_target_group_arn` | Target group ARN for NLB |
| `nlb_listener_id`      | NLB listener ID          |
| `nlb_listener_arn`     | NLB listener ARN         |

### 🛡️ Security Groups
| Name                     | Description                             |
|--------------------------|-----------------------------------------|
| `alb_sg_id`              | Security Group ID for ALB               |
| `nlb_sg_id`              | Security Group ID for NLB               |
| `public_instance_sg_id`  | Security Group ID for public instances  |
| `private_instance_sg_id` | Security Group ID for private instances |


---

## 🏗️ Example Usage

```hcl
module "servers" {
  source = "./Modules/servers"

  amazon_or_ubuntu           = "ubuntu"
  environment                = "dev"
  create_key_pair            = true
  public_key_path            = "~/.ssh/id_rsa.pub"

  create_public_instance     = true
  public_instance_type       = "t3.micro"
  public_subnet_id           = ["subnet-12345"]
  add_public_instance_user_data = true
  public_instance_user_data  = file("user-data.sh")

  create_private_instance    = true
  private_instance_type      = "t3.micro"
  private_subnet_id          = ["subnet-67890"]
  add_private_instance_user_data = true
  private_instance_user_data = file("private-user-data.sh")

  single_lb                  = false
  availability_zone          = ["us-east-1a", "us-east-1b"]
  vpc_id                     = "vpc-abcde123"
  my_public_ip               = "203.0.113.10"

  tags = {
    Project     = "3-tier-app"
    Environment = "dev"
  }
}
```

## 📚 Notes
- Make sure your provided public_key_path is accessible to Terraform.
- Use different subnets for public and private instances for better isolation.
- User data scripts should be validated for syntax before deployment.
- Use single_lb = true only if your architecture supports a unified load balancing approach.