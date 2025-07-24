# Internet Gateway
resource "aws_internet_gateway" "subrat_igw" {
  vpc_id = aws_vpc.subrat_vpc.id

  tags = {
    Name = "subrat-igw"
  }
}

# Route Table
resource "aws_route_table" "subrat_public_rt" {
  vpc_id = aws_vpc.subrat_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.subrat_igw.id
  }

  tags = {
    Name = "subrat-public-rt"
  }
}

# Route Table Association for subnet-1 (ap-south-1a)
resource "aws_route_table_association" "rt_assoc_subnet1" {
  subnet_id      = aws_subnet.himansu_subnet.id
  route_table_id = aws_route_table.subrat_public_rt.id
}

# Route Table Association for subnet-2 (ap-south-1b)
resource "aws_route_table_association" "rt_assoc_subnet2" {
  subnet_id      = aws_subnet.himansu_subnet_2.id
  route_table_id = aws_route_table.subrat_public_rt.id
}
