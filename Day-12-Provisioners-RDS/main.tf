#without S3

provider "aws" {
  region = "ap-south-1"
}

# 1. VPC
resource "aws_vpc" "cust_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cust-vpc"
  }
}

# 2. Subnets
resource "aws_subnet" "cust_sub_pub" {
  vpc_id                  = aws_vpc.cust_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cust-sub-pub"
  }
}

resource "aws_subnet" "cust_sub_priv" {
  vpc_id            = aws_vpc.cust_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "cust-sub-priv"
  }
}

resource "aws_subnet" "cust_sub_priv_b" {
  vpc_id            = aws_vpc.cust_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "cust-sub-priv-b"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "cust_igw" {
  vpc_id = aws_vpc.cust_vpc.id

  tags = {
    Name = "cust-igw"
  }
}

# 4. Route Table for Public Subnet
resource "aws_route_table" "cust_pub_rt" {
  vpc_id = aws_vpc.cust_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cust_igw.id
  }

  tags = {
    Name = "cust-public-rt"
  }
}

# 5. Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "cust_pub_rt_assoc" {
  subnet_id      = aws_subnet.cust_sub_pub.id
  route_table_id = aws_route_table.cust_pub_rt.id
}

# 6. Security Group
resource "aws_security_group" "MUM_SG" {
  name        = "cust-db-sg"
  description = "Allow MySQL and HTTP within VPC"
  vpc_id      = aws_vpc.cust_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cust-db-sg"
  }
}

# 7. DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "cust-db-subnet-group"
  subnet_ids = [aws_subnet.cust_sub_priv.id, aws_subnet.cust_sub_priv_b.id]

  tags = {
    Name = "cust-db-subnet-group"
  }
}

# 8. Secrets Manager for DB Credentials
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "cust-db-credentials-v2"  # or any other unique name
}


resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    "username" = "admin",
    "password" = "admin1234"
  })
}

# 9. RDS DB Instance
resource "aws_db_instance" "db_instance" {
  identifier             = "cust-db-instance"
  engine                 = "mysql"
  engine_version         = "8.0.41"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = "admin1234"
  db_name                = "custdb"
  vpc_security_group_ids = [aws_security_group.MUM_SG.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "cust-db-instance"
  }
}

# 10. IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "cust-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# 11. IAM Policy Attachment (Only Secrets Manager Access)
resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# 12. IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "cust-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# 13. EC2 Instance in Public Subnet
resource "aws_instance" "ec2_instance" {
  ami                         = "ami-062f0cc54dbfd8ef1"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.cust_sub_pub.id
  associate_public_ip_address = true
  key_name                    = "AWScustomkey"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.MUM_SG.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mariadb
              EOF

  tags = {
    Name = "cust-ec2"
  }
}

#14. Null Resource to Trigger DB Initialization

resource "null_resource" "db_init_trigger" {
  depends_on = [aws_instance.ec2_instance]

  triggers = {
    instance_id = aws_instance.ec2_instance.id
    script_hash = filesha256("C:/Project/Terraform/Day-12-Provisioners-RDS/init.sql")
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/lenovo/Downloads/AWSkeys/AWScustomkey.pem")
    host        = aws_instance.ec2_instance.public_ip
  }
 #First: Upload the SQL file
  provisioner "file" {
    source      = "C:/Project/Terraform/Day-12-Provisioners-RDS/init.sql"
    destination = "/tmp/init.sql"
  }

  #Then: Run the script
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y mariadb105-server jq aws-cli",
      "DB_USERNAME=$(aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.rds_secret.id} --query SecretString --output text | jq -r .username)",
      "DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.rds_secret.id} --query SecretString --output text | jq -r .password)",
      "echo 'Running the SQL script on RDS instance...'",
      "mysql -h ${aws_db_instance.db_instance.address} -u $DB_USERNAME -p$DB_PASSWORD < /tmp/init.sql"
    ]
  }
}
