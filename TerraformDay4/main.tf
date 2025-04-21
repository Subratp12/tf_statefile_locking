resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "Cust_VPC"
  }
}
resource "aws_subnet" "subnet_dev" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "Dev_Subnet"
  }

}
resource "aws_subnet" "subnet_test" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Test_Subnet"
  }

}
resource "aws_subnet" "subnet_prod" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Prod_Subnet"
  }

}

resource "aws_subnet" "subnet_UAT" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.4.0/24"
    tags = {
        Name = "UAT_Subnet"
    }
  
}