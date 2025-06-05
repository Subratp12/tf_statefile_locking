data "aws_ami" "call_out_ami_fe" {
  most_recent = true
  owners      = ["self"] # Replace with the AWS account ID if needed

  filter {
    name   = "name"
    values = ["frontend-ami"] 
  }
    tags = {
    Name = "FE-AMI"
  }
}

# Launch Template Resource
resource "aws_launch_template" "frontend" {
  name = "frontend-LT"
  description = "frontend-terraform-LT"
  image_id = data.aws_ami.call_out_ami_fe.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.key_name
  user_data = filebase64("${path.module}/frontend-lt.sh")
  #default_version = 1
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Frontend-LT"
    }
  }
}