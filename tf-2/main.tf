provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "example_ec2" {
  ami           = "ami-06727c0fe04eb2bd2" 
  instance_type = "t2.micro"              
  tags = {
    Name = "Example-EC2"                 
  }
}