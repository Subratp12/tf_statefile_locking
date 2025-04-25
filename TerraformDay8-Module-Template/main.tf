resource "aws_vpc" "TF_VPC" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "TF_sub_Pub_1" {
  vpc_id                  = aws_vpc.TF_VPC.id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "TF_sub_Pub_1"
  }
}

resource "aws_subnet" "TF_sub_Pub_2" {
  vpc_id                  = aws_vpc.TF_VPC.id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "TF_sub_Pub_2"
  }
}

resource "aws_subnet" "TF_sub_pvt_1" {
  vpc_id                  = aws_vpc.TF_VPC.id
  cidr_block              = var.pvt_subnet_cidr[0]
  availability_zone       = var.availability_zone[0]
  tags = {
    Name = "TF_sub_pvt_1"
  }
}

resource "aws_subnet" "TF_sub_pvt_2" {
  vpc_id                  = aws_vpc.TF_VPC.id
  cidr_block              = var.pvt_subnet_cidr[1]
  availability_zone       = var.availability_zone[1]
  tags = {
    Name = "TF_sub_pvt_2"
  }
}

resource "aws_security_group" "TF_SG" {
  vpc_id = aws_vpc.TF_VPC.id
  name   = var.security_group_name

  tags = {
    Name = var.security_group_name
  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "TF_EC2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
}

resource "random_string" "bucket_suffix" {
  length  = var.bucket_suffix_length
  special = var.bucket_suffix_special
}


resource "aws_s3_bucket" "TF_S3" {
  bucket = "${var.s3_bucket_name}-${random_string.bucket_suffix.result}"

  tags = {
    Name = "${var.s3_bucket_name}-${random_string.bucket_suffix.result}"
  }
}

