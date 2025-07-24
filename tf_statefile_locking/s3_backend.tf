resource "aws_s3_bucket" "tf_state_bucket" {
  bucket        = "terraform-collab-state"
  force_destroy = true

  tags = {
    Name        = "Terraform Remote State Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}