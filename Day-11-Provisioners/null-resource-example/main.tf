# PROVIDER BLOCK
provider "aws" {
  region = "ap-south-1"
}

# S3 BUCKET CREATION
resource "aws_s3_bucket" "my_bucket" {
  bucket = "sub12rat94"   # New bucket name
  force_destroy = true    # Optional: allows bucket deletion even if it has objects inside
}

# IAM POLICY TO ACCESS S3 BUCKET
resource "aws_iam_policy" "s3_access_policy" {
  name        = "EC2S3AccessPolicy"
  description = "Policy for EC2 instances to access S3"
  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.my_bucket.arn,
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
}

# IAM ROLE FOR EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

# ATTACH IAM POLICY TO THE ROLE
resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# IAM INSTANCE PROFILE FOR EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_s3_access_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# CREATE EC2 INSTANCE
resource "aws_instance" "web_server" {
  ami                  = "ami-0f1dcc636b69a6438" # Amazon Linux 2 AMI for ap-south-1 (Mumbai)
  instance_type        = "t2.micro"
  key_name             = "AWScustomkey"
  security_groups      = ["default"]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  availability_zone    = "ap-south-1b"

  tags = {
    Name = "MyWebServer_1b"
  }
}

# resource "aws_instance" "web_server1" {
#   ami                  = "ami-0f1dcc636b69a6438" # Amazon Linux 2 AMI for ap-south-1 (Mumbai)
#   instance_type        = "t2.micro"
#   key_name             = "AWScustomkey"
#   security_groups      = ["default"]
#   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
#   availability_zone    = "ap-south-1c"

#   tags = {
#     Name = "MyWebServer_1c"
#   }
# }

# NULL RESOURCE FOR REMOTE EXECUTION ON EC2
resource "null_resource" "setup_and_upload" {
  depends_on = [aws_instance.web_server]

  provisioner "remote-exec" {
    inline = [
      # Install Apache
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",

      # Ensure /var/www/html directory exists
      "sudo mkdir -p /var/www/html/",

      # Create index.html
      "echo '<h1>Welcome to My Web Server.How are you all doing?</h1>' | sudo tee /var/www/html/index.html",

      # Install AWS CLI if not already installed
      "sudo yum install -y awscli",

      # Upload file to S3
      "aws s3 cp /var/www/html/index.html s3://${aws_s3_bucket.my_bucket.bucket}/",
      "echo 'File uploaded successfully to S3 bucket ${aws_s3_bucket.my_bucket.bucket}'"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/AWScustomkey.pem")
    host        = aws_instance.web_server.public_ip
  }

  triggers = {
    instance_id = aws_instance.web_server.id
  }
}
