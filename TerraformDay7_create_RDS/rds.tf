# -------------------- RDS Subnet Group --------------------
resource "aws_db_subnet_group" "TF_SUB_GRP" {
  name       = "cust_subnet_group"
  subnet_ids = [aws_subnet.TF_Subnet_Pvt1.id, aws_subnet.TF_Subnet_Pvt2.id]
  tags = {
    Name = "cust_subnet_group"
  }
}

# Create Free-tier MySQL RDS Instance
resource "aws_db_instance" "cust_rds" {
  identifier             = "cust-rds"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = "db.t4g.micro"  # Free-tier eligible instance class
  username               = "admin"
  password               = "password123"
  db_subnet_group_name   = aws_db_subnet_group.TF_SUB_GRP.name  # Correct reference
  vpc_security_group_ids = [aws_security_group.TF_SG.id]
  publicly_accessible    = false  # Ensure no public access
  multi_az               = false  # Optional, set to true for Multi-AZ for durability
  storage_type           = "gp2"  # Default for free-tier

  tags = {
    Name = "cust_rds"
  }

  # Additional settings for free-tier and cost control
  skip_final_snapshot = true  # Avoid snapshot at deletion (good for dev/test)
  deletion_protection = false  # Allow RDS instance to be deleted
}

# Output the RDS Endpoint and DB Identifier
output "db_endpoint" {
  description = "The endpoint of the RDS DB instance"
  value       = aws_db_instance.cust_rds.endpoint
}

output "db_instance_identifier" {
  description = "The identifier of the RDS DB instance"
  value       = aws_db_instance.cust_rds.id
}
