# Create Target Group
resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  depends_on = [ aws_vpc.vpc ]

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "FE-TG"
  }
}


#  Create Load Balancer
resource "aws_lb" "frontend_alb" {
  name               = "FE-LB-1"
  load_balancer_type = "application"
  internal          = false  # This ensures the ALB is public
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.pub_1.id, aws_subnet.pub_2.id]

  tags = {
    Name = "FE-LB"
  }
}

#  Create Listener for ALB
resource "aws_lb_listener" "frontend_alb_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
  depends_on = [ aws_lb_target_group.frontend_tg ]
}