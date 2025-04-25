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


# resource "aws_subnet" "TF_sub_Pub" {
#   count = length(var.public_subnet_cidr)

#   vpc_id                  = aws_vpc.TF_VPC.id
#   cidr_block              = var.public_subnet_cidr[count.index]
#   availability_zone       = var.availability_zone[count.index]
#   map_public_ip_on_launch = var.map_public_ip_on_launch

#   tags = {
#     Name = "TF_sub_Pub-${count.index + 1}"
#   }
# }