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