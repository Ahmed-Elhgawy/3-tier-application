# In This File the Script which creates Application Load Balancer, and its dependency

# Public Subnets for ALB
locals {
  subnets_num = var.single_lb ? 1 : 2
}

resource "aws_subnet" "alb_subnets" {
  count                   = local.subnets_num
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_id, 8, 201 + count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, var.tags, {
    Name                     = "alb_subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "share"
    Public                   = "true"
  })
}

# Application Load Balancer
resource "aws_lb_target_group" "alb_target_group" {
  name            = "alb-target-group"
  port            = 3000
  protocol        = "TCP"
  target_type     = "instance"
  ip_address_type = "ipv4"
  vpc_id          = var.vpc_id
  health_check {
    enabled             = true
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
  tags = merge(local.common_tags, var.tags, {
    Name = "alb-target-group"
  })
}
resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  for_each = {
    for k, v in aws_instance.public_instance :
    k => v
  }

  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = each.value.id
  port             = 3000
}
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.alb_subnets : s.id]
  ip_address_type    = "ipv4"

  enable_deletion_protection = false

  tags = merge(local.common_tags, var.tags, {
    Name = "alb"
  })
}
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 3000
  protocol          = "TCP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group.arn
      }
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]

  tags = merge(local.common_tags, var.tags, {
    Name = "alb-listener"
  })
}