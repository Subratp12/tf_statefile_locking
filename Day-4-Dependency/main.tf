resource "aws_instance" "dependency" {
  ami           = "ami-05cef57fad40b2755"
  instance_type = "t3.micro"
  key_name      = "AWS_hyd"
  
  tags = {
    Name = "Devops_EC2"
  }

}

resource "aws_vpc" "VPC_AWS" {
  cidr_block = "192.0.0.0/20"
  tags = {
    Name = "Second_VPC"
  }
  depends_on = [aws_instance.dependency]

}