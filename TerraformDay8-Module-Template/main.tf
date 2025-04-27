resource "aws_s3_bucket" "TF_Bucket" {
  bucket = var.S3_bucket
  count  = var.S3_bucket != "" ? 1 : 0
  tags   = {
    Name = "TF-S3-Bucket"
  }
  
}

resource "aws_instance" "TF_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
}
