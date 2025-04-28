provider "aws" {
  region = var.region
}

# Create the S3 bucket
resource "aws_s3_bucket" "TF_S3" {
  bucket        = var.bucket_name
  tags = {
    Name = "Cust-S3-Bucket"
  }
  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.TF_S3.id

  versioning_configuration {
    status = var.versioning_status
  }
}

