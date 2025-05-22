# Public Subnet Output
output "public_instance_ids" {
  description = "Public Subnet IDs"
  value       = [for i in aws_instance.public_instance : i.id]
}
output "public_instance_arns" {
  description = "Public Subnet ARNs"
  value       = [for i in aws_instance.public_instance : i.arn]
}
output "public_instance_public_dns" {
  description = "Public Subnet Public DNS"
  value       = [for i in aws_instance.public_instance : i.public_dns]
}
output "public_instance_private_ip" {
  description = "Public Subnet Private IP"
  value       = [for i in aws_instance.public_instance : i.private_ip]
}

# Private Subnet Output
output "private_instance_ids" {
  description = "Private Subnet IDs"
  value       = [for i in aws_instance.private_instance : i.id]
}
output "private_instance_arns" {
  description = "Private Subnet ARNs"
  value       = [for i in aws_instance.private_instance : i.arn]
}
output "private_instance_private_ip" {
  description = "Private Subnet Private IP"
  value       = [for i in aws_instance.private_instance : i.private_ip]
}

# ALB Output
output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_lb.alb.dns_name
}
output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.alb.arn
}

output "alb_target_group_id" {
  description = "ALB Target Group ID"
  value       = aws_lb_target_group.alb_target_group.id
}
output "alb_target_group_arn" {
  description = "ALB Target Group ARN"
  value       = aws_lb_target_group.alb_target_group.arn
}

output "alb_listener_arn" {
  description = "ALB Listener ARN"
  value       = aws_lb_listener.alb_listener.arn
}
output "alb_listener_id" {
  description = "ALB Listener ID"
  value       = aws_lb_listener.alb_listener.id
}

# NLB Output
output "nlb_dns_name" {
  description = "NLB DNS Name"
  value       = aws_lb.nlb.dns_name
}
output "nlb_arn" {
  description = "NLB ARN"
  value       = aws_lb.nlb.arn
}

output "nlb_target_group_arn" {
  description = "NLB Target Group ARN"
  value       = aws_lb_target_group.nlb_target_group.arn
}
output "nlb_target_group_id" {
  description = "NLB Target Group ID"
  value       = aws_lb_target_group.nlb_target_group.id
}

output "nlb_listener_arn" {
  description = "NLB Listener ARN"
  value       = aws_lb_listener.nlb_listener.arn
}
output "nlb_listener_id" {
  description = "NLB Listener ID"
  value       = aws_lb_listener.nlb_listener.id
}

# Security Group Output
output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb_sg.id
}
output "public_instance_sg_id" {
  description = "Public Instance Security Group ID"
  value       = aws_security_group.public_instance_sg.id
}
output "nlb_sg_id" {
  description = "NLB Security Group ID"
  value       = aws_security_group.nlb_sg.id
}
output "private_instance_sg_id" {
  description = "Private Instance Security Group ID"
  value       = aws_security_group.private_instance_sg.id
}
