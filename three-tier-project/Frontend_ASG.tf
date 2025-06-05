resource "aws_autoscaling_group" "frontend-asg" {
  name_prefix = "frontend-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.pvt_1.id, aws_subnet.pvt_2.id]
  target_group_arns = [aws_lb_target_group.frontend_tg.arn]
  
  health_check_type = "EC2"
  #health_check_grace_period = 300 # default is 300 seconds  
  # Launch Template
  launch_template {
    id      = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.latest_version
  }
  # Instance Refresh
   instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }
    triggers = [ /*"launch_template",*/ "desired_capacity" ] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  } 
  tag {
    key                 = "Name"
    value               = "FE-asg"
    propagate_at_launch = true
  }      
}