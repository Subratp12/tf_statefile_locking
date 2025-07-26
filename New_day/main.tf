resource "aws_instance" "EC2_instance" {
  ami           = "ami-0d0ad8bb301edb745"
  instance_type = "t2.micro"
  tags = {
    Name = "SubratEc2"
  }
}

resource "aws_s3_bucket" "S3_bucket" {
  bucket = "subpad-bucket"
  tags = {
    Name        = "SubratS3Bucket"
    Environment = "Dev"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.S3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.S3_bucket.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.S3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.S3_bucket.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_public_access_block.public_access,
    aws_s3_bucket_ownership_controls.ownership_controls
  ]
}

resource "aws_dynamodb_table" "DynamoDB_table" {
  name         = "SubratDynamoDBTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "SubratDynamoDBTable"
    Environment = "Dev"
  }
}