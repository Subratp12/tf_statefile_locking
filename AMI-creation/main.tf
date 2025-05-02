# 1. Creation of VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Custom-VPC-1"
  }
}

# 2.1 Creation of Public Subnets
resource "aws_subnet" "pub_1" {
  cidr_block        = "10.0.0.0/21"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Public-subnet-1"
  }
}

# resource "aws_subnet" "pub_2" {
#     cidr_block = var.public_subnets.pub_2
#     vpc_id = aws_vpc.vpc.id
#     availability_zone = "ap-south-1b"
#     tags = {
#         Name = "Public-subnet-2"
#     }
# }

# # 2.2 Creation of Private Subnets
# resource "aws_subnet" "pvt_1" {
#     cidr_block = var.private_subnets.pvt_1
#     vpc_id = aws_vpc.vpc.id
#     availability_zone = "ap-south-1a"
#     tags = {
#         Name = "Private-subnet-1"
#     }
# }

# resource "aws_subnet" "pvt_2" {
#     cidr_block = var.private_subnets.pvt_2
#     vpc_id = aws_vpc.vpc.id
#     availability_zone = "ap-south-1b"
#     tags = {
#         Name = "Private-subnet-2"
#     }
# }

# 3. Creation of IG
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Cust-IGW"
  }
}

# # 4. Creation of ELastic IP
# resource "aws_eip" "eip" {
#     domain = "vpc"
#     tags = {
#       Name = "NAT-EIP"
#     }
# }

# # 5. Creation of NAT Gateway 
# resource "aws_nat_gateway" "nat_1az" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.pub_1.id
#   tags = {
#     Name = "Cust NAT GW-1"
#   }
#   depends_on = [aws_internet_gateway.igw]

# }


# 6. Creation of RT & Edit Routes
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

# resource "aws_route_table" "pvt_rt_1" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_1az.id
#   }
#   tags = {
#     Name = "private-rt-1"
#   }
# }

# resource "aws_route_table" "pvt_rt_2" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_1az.id
#   }
#   tags = {
#     Name = "private-rt-2"
#   }
# }

# 8.1 Public Subnet association
resource "aws_route_table_association" "pub_sub_1" {
  subnet_id      = aws_subnet.pub_1.id
  route_table_id = aws_route_table.pub_rt.id
}

# resource "aws_route_table_association" "pub_sub_2" {
#   subnet_id      = aws_subnet.pub_2.id
#   route_table_id = aws_route_table.pub_rt.id
# }

# # 8.2 Private Subnet association
# resource "aws_route_table_association" "pvt_sub_1" {
#   subnet_id      = aws_subnet.pvt_1.id
#   route_table_id = aws_route_table.pvt_rt_1.id
# }

# resource "aws_route_table_association" "pvt_sub_2" {
#   subnet_id      = aws_subnet.pvt_2.id
#   route_table_id = aws_route_table.pvt_rt_1.id
# }

resource "aws_instance" "TF_EC2" {
  ami               = "ami-062f0cc54dbfd8ef1" # Amazon Linux 2 AMI for ap-south-1 (Mumbai)
  instance_type     = "t2.micro"
  key_name          = "AWScustomkey"
  security_groups   = ["default"]
  availability_zone = "ap-south-1a"

  tags = {
    Name = "MyWebServer_1a"
  }

}

resource "aws_ami_from_instance" "TF_EC2_ami" {
  name               = "TF_EC2_ami"
  source_instance_id = aws_instance.TF_EC2.id
  snapshot_without_reboot = true
  tags = {
    Name = "TF_EC2_ami"
  }
  
}

resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my-launch-template-"
  image_id      = "ami-02239d3d0403c323a"
  instance_type = "t2.micro"
  key_name      = "AWScustomkey"

  #vpc_security_group_ids = [aws_instance.TF_EC2.security_groups[0]] # Same SG as EC2
vpc_security_group_ids = [tolist(aws_instance.TF_EC2.security_groups)[0]]

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.pub_1.id
    device_index                = 0
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "EC2-from-LT"
    }
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 10
      volume_type = "gp2"
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "MyLaunchTemplate"
  }
}
