#VPC Creation
resource "aws_vpc" "TF_VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Cust_VPC"
  }
}

# Internet Gateway Creation
resource "aws_internet_gateway" "TF_IGW" {
  vpc_id = aws_vpc.TF_VPC.id

  tags = {
    Name = "Cust_IGW"
  }
}

# Public Subnets
resource "aws_subnet" "TF_sub_Pub_1" {
  vpc_id                  = aws_vpc.TF_VPC.id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "sub_Pub_1"
  }
}

resource "aws_subnet" "TF_sub_Pub_2" {
  vpc_id                  = aws_vpc.TF_VPC.id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "sub_Pub_2"
  }
}

# # Route Table for Public Subnets
# resource "aws_route_table" "TF_pub_RT" {
#     vpc_id = aws_vpc.TF_VPC.id
#     tags = {
#         Name = var.route_table_name
#     }
#     route {
#         cidr_block = var.route_cidr_block
#         gateway_id = aws_internet_gateway.TF_IGW.id
#     }
# }


# resource "aws_route_table_association" "TF_pub_RT_association_1" {
#     subnet_id      = aws_subnet.TF_sub_Pub_1.id
#     route_table_id = aws_route_table.TF_pub_RT.id
# }

# resource "aws_route_table_association" "TF_pub_RT_association_2" {
#     subnet_id      = aws_subnet.TF_sub_Pub_2.id
#     route_table_id = aws_route_table.TF_pub_RT.id
# }


# Private Subnets

resource "aws_subnet" "TF_sub_Pvt_1" {
  vpc_id            = aws_vpc.TF_VPC.id
  cidr_block        = var.pvt_sub_cidr[0]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "sub_Pvt_1"
  }
}

resource "aws_subnet" "TF_sub_Pvt_2" {
  vpc_id            = aws_vpc.TF_VPC.id
  cidr_block        = var.pvt_sub_cidr[1]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "sub_Pvt_2"
  }
}


#EC2 Instances

resource "aws_instance" "TF_EC2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.TF_sub_Pub_1.id

  tags = {
    Name = "Cust-EC2"
  }

}

resource "aws_instance" "TF_EC2_2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.TF_sub_Pub_2.id


  tags = {
    Name = "Cust-EC2-2"
  }

}
#Private EC2 Instance

resource "aws_instance" "TF_pvt_ec2_1" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = aws_subnet.TF_sub_Pvt_1.id
  availability_zone = var.availability_zone[0]
  tags = {
    Name = "Cust-EC2-Pvt-1"
  }
}

resource "aws_instance" "TF_pvt_ec2_2" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = aws_subnet.TF_sub_Pvt_2.id
  availability_zone = var.availability_zone[1]
  tags = {
    Name = "Cust-EC2-Pvt-2"
  }

}

resource "aws_s3_bucket" "bucket" {
  bucket = var.S3_bucket

}