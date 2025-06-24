resource "aws_lb" "alb" {
  name               = "proj-2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.subnets

  tags = {
    Environment = "proj-2-alb"
  }
}

resource "aws_lb_listener" "istener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_grp.arn
  }
}

resource "aws_lb_target_group" "target_grp" {
  name     = "target-grp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_target_group_attachment" "tg_a" {
  count = length(var.ec2)
  target_group_arn = aws_lb_target_group.target_grp.arn
  target_id        = var.ec2[count.index]
  port             = 80
}