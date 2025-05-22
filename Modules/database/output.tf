output "db_public_endpoint" {
  description = "DB Public Endpoint"
  value       = aws_db_instance.db_instance.endpoint
}

output "db_instance_id" {
  description = "DB Instance ID"
  value       = aws_db_instance.db_instance.id
}
output "db_instance_arn" {
  description = "DB Instance ARN"
  value       = aws_db_instance.db_instance.arn
}
output "db_instance_name" {
  description = "DB Instance Name"
  value       = aws_db_instance.db_instance.db_name
}
output "db_instance_address" {
  description = "DB Instance Address"
  value       = aws_db_instance.db_instance.address
}
output "db_instance_port" {
  description = "DB Instance Port"
  value       = aws_db_instance.db_instance.port
}

output "db_security_group_id" {
  description = "DB Security Group ID"
  value       = aws_security_group.db_security_group.id
}
output "db_security_group_arn" {
  description = "DB Security Group ARN"
  value       = aws_security_group.db_security_group.arn
}
