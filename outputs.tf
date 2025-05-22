output "public_instance_public_dns" {
  description = "Public Instance Public DNS"
  value       = module.servers.public_instance_public_dns
}

output "private_instance_private_ip" {
  description = "Private Instance Private IP"
  value       = module.servers.private_instance_private_ip
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.servers.alb_dns_name
}

output "nlb_dns_name" {
  description = "NLB DNS Name"
  value       = module.servers.nlb_dns_name
}

output "db_public_endpoint" {
  description = "DB Public Endpoint"
  value       = module.database.db_public_endpoint
}