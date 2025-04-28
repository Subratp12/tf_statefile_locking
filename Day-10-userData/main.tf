resource "aws_instance" "TF_EC2" {
  ami                         = "ami-002f6e91abff6eb96" # Replace with a valid AMI ID for ap-south-1
  instance_type               = "t2.micro"
  key_name                    = "AWScustomkey"
  subnet_id                   = "subnet-0e28f94b113e0b31b"
  associate_public_ip_address = true
  user_data = file("test.sh")
  tags = {
    Name = "TF_userData"
  }
}