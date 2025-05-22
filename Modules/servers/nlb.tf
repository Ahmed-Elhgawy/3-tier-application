# In This File the script which cretes Network Load Balancer, and its dependency

# Private Subnets for NLB
resource "aws_subnet" "nlb_subnets" {
  count                   = local.subnets_num
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_id, 8, 211 + count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, var.tags, {
    Name                              = "nlb_subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "shared"
    Public                            = "false"
  })
}

resource "aws_lb_target_group" "nlb_target_group" {
  name            = "nlb-target-group"
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
    Name = "nlb-target-group"
  })
}
resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
  for_each = {
    for k, v in aws_instance.private_instance :
    k => v
  }

  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = each.value.id
  port             = 3000
}
resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = [for s in aws_subnet.nlb_subnets : s.id]
  ip_address_type    = "ipv4"

  enable_deletion_protection = false

  tags = merge(local.common_tags, var.tags, {
    Name = "nlb"
  })
}
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 3000
  protocol          = "TCP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.nlb_target_group.arn
      }
    }
  }

  depends_on = [aws_lb_target_group.nlb_target_group]

  tags = merge(local.common_tags, var.tags, {
    Name = "nlb-listener"
  })
}