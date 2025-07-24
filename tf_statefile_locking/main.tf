resource "aws_vpc" "subrat_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "subrat-vpc"
  }
}

resource "aws_subnet" "himansu_subnet" {
  vpc_id                  = aws_vpc.subrat_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subrat-subnet"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0b32d400456908bf9"  # Example AMI for Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = "subnet-0ef215cc011e0f20d"  # Existing subnet in your VPC

  # vpc_security_group_ids = ["sg-0123456789abcdef0"]  # Existing SG
  tags = {
     Name = "subrat-EC2"
  }

}

resource "aws_s3_bucket" "practice" {
  bucket = "gayatridevops"
  
}