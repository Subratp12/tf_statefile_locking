provider "aws" {
  region = "ap-south-2"
    
}

resource "aws_s3_bucket" "S3Bucket" {
    bucket = "sub12rat94"
 
    tags = {
        Name        = "S3Bucket"
        Environment = "Dev"
    }
  
}
resource "aws_dynamodb_table" "DynamoDBTable" {
    name         = "subrat-dynamodb-table"
    hash_key     = "LockID"
    read_capacity  = 20
    write_capacity = 20

    attribute {
        name = "LockID"
        type = "S"
    }
}