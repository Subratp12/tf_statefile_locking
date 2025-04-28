resource "aws_vpc" "TF_VPC" {
    cidr_block ="10.0.0.0/20"
    tags = {
      Name = "my-vpc"
    }
  
}

resource "aws_subnet" "TF_subnet" {
    vpc_id = "vpc-07e25c65bbcd2d79d"
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "my-sub"
    }

  
}

resource "aws_internet_gateway" "TF_IGW" {
    vpc_id = "vpc-07e25c65bbcd2d79d"
    tags = {
        Name = "IGW"
    }
  
}

resource "aws_route_table" "TF_RT" {
    vpc_id="vpc-07e25c65bbcd2d79d"
    route {
        cidr_block = "0.0.0.0/0"
gateway_id = "igw-00c0af56a5ac9fe41"
    }
    tags = {
        Name = "RT"
    }
}

resource "aws_route_table_association" "TF_RT_association" {
    subnet_id = "subnet-0e28f94b113e0b31b"
    route_table_id = "rtb-05f9961dff04dedac"
  }


resource "aws_instance" "TF_EC2" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    key_name = "AWScustomkey"
    subnet_id = "subnet-0e28f94b113e0b31b"
    associate_public_ip_address = true
    tags = {
      Name = "ec2"
    }
  
}