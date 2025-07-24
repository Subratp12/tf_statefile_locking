resource "aws_db_subnet_group" "subrat" {
  name       = "subrat-subnet-group"
  subnet_ids = [
    aws_subnet.himansu_subnet.id,
    aws_subnet.himansu_subnet_2.id
  ]

  tags = {
    Name = "subrat-db-subnet-group"
  }
}

resource "aws_subnet" "himansu_subnet_2" {
  vpc_id                  = aws_vpc.subrat_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subrat-subnet_2"
  }
}


resource "aws_db_instance" "subrat_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "subratdb"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.subrat.name  # ✅ Direct reference

  tags = {
    Name = "subrat-rds"
  }
}