data "aws_ami" "call_out_ami_be" {
  most_recent = true
  owners      = ["self"] # Replace with the AWS account ID if needed

  filter {
    name   = "name"
    values = ["backend-ami"] 
  }
  tags = {
    Name = "BE-AMI"
  }
}


# Launch Template Resource
resource "aws_launch_template" "backend" {
  name = "Backend-LT"
  description = "Backend-terraform-LT"
  image_id = data.aws_ami.call_out_ami_be.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.key_name
  user_data = filebase64("${path.module}/backend-lt.sh")
  #default_version = 1
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Backend-LT"
    }
  }
}