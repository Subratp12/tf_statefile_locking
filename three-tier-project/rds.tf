# Creation of RDS DB

resource "aws_db_subnet_group" "sub_group_db" {
  tags = {
    Name = "DB Subnet Group"
  }
  description = "creating subnet group for db"
  name        = "subnet group"
  subnet_ids  = [aws_subnet.pvt_5.id, aws_subnet.pvt_6.id]
  depends_on  = [aws_subnet.pvt_5, aws_subnet.pvt_6]

}

# parameter group
resource "aws_db_parameter_group" "pg_db" {
  name_prefix = "my-pg"
  family      = "mysql8.0"
}

# db instance
resource "aws_db_instance" "rds_test" {
  engine                   = "mysql"
  engine_version           = "8.0.41"
  multi_az                 = false
  identifier               = "book-rds"
  db_name                  = "mydb"
  username                 = var.db_username
  password                 = var.db_password
  instance_class           = var.instance_class
  parameter_group_name     = aws_db_parameter_group.pg_db.name
  storage_type             = "gp2"
  allocated_storage        = 10
  db_subnet_group_name     = aws_db_subnet_group.sub_group_db.name
  publicly_accessible      = false
  vpc_security_group_ids   = [aws_security_group.sg.id]
  availability_zone        = "ap-south-1a"
  skip_final_snapshot      = true
  delete_automated_backups = true
  backup_retention_period  = 7
  tags = {
    DB_identifier = "book-rds"
  }

}
