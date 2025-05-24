# Database Module

This Terraform module provisions a managed relational database instance (RDS) in AWS. It supports configuration for various database engines (e.g., MySQL, PostgreSQL), multi-AZ deployment, subnet group usage, and security settings such as CIDR-based and Security Group-based access.

---

## 🧱 Features

- Deploy a managed RDS database instance (e.g., MySQL, PostgreSQL).
- Configure DB engine, version (via family), username, password.
- Support for Multi-AZ high availability deployment.
- Automatically creates a secure Security Group allowing access from specific CIDR or Security Group.
- Output important connection and metadata details for integration.

---

## 📥 Input Variables

| Name              | Description                                                | Type          | Default                     | Required |
|-------------------|------------------------------------------------------------|---------------|-----------------------------|:--------:|
| `db_family`       | DB parameter group family (e.g., `mysql8.0`, `postgres13`) | `string`      |       —                     | ✅      |
| `db_engine`       | The DB engine to use      (e.g., `mysql`, `postgres`)      | `string`      |       —                     | ✅      |
| `environment`     | Name of the environment   (e.g., `dev`, `prod`)            | `string`      |       —                     | ✅      |
| `db_username`     | Master username for the database                           | `string`      |       —                     | ✅      |
| `db_password`     | Master password for the database                           | `string`      |       —                     | ✅      |
| `db_subnet_group` | The name of the DB subnet group to launch into             | `string`      |       —                     | ✅      |
| `multi_az`        | Whether to deploy the DB in multiple AZs                   | `bool`        |       —                     | ✅      |
| `vpc_id`          | ID of the VPC in which resources are deployed              | `string`      |       —                     | ✅      |
| `allowed_cidr`    | CIDR block(s) allowed to access the DB                     | `string`      |       —                     | ✅      |
| `allowed_sg`      | Security Group ID allowed to access the DB                 | `string`      |       —                     | ✅      |
| `tags`            | Tags applied to all resources                              | `map(string)` | `{ "module" = "database" }` | ❌      |

---

## 📤 Outputs

| Name                    | Description                                 |
|-------------------------|---------------------------------------------|
| `db_public_endpoint`    | Public endpoint of the database             |
| `db_instance_id`        | RDS instance ID                             |
| `db_instance_arn`       | ARN of the RDS instance                     |
| `db_instance_name`      | Database name                               |
| `db_instance_address`   | DNS address of the database                 |
| `db_instance_port`      | Port on which the DB is listening           |
| `db_security_group_id`  | ID of the Security Group attached to the DB |
| `db_security_group_arn` | ARN of the DB Security Group                |

---

## 🧪 Example Usage

```hcl
module "database" {
  source = "./Modules/database"

  db_family        = "mysql8.0"
  db_engine        = "mysql"
  environment      = "dev"
  db_username      = "admin"
  db_password      = "your-secret-password"
  db_subnet_group  = "rds-subnet-group"
  multi_az         = true
  vpc_id           = "vpc-abc123"
  allowed_cidr     = "10.0.0.0/16"
  allowed_sg       = "sg-12345678"

  tags = {
    Project     = "3-tier-app"
    Environment = "dev"
  }
}
```

---

## 📚 Notes

- The db_password variable is marked as sensitive and will not be displayed in Terraform output.
- You must provide a pre-existing DB subnet group for deployment.
- Security Group access can be defined using both CIDR and SG rules to support multiple access methods.
- Make sure multi_az = true only if high availability is required (adds cost).

---