resource "aws_instance" "EC2" {
  ami = var.ami_id # Replace with a valid AMI ID for ap-south-1
  instance_type = var.instance_type
    key_name = var.key_name
  tags = {
    Name = "mum-ec2"
}
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

