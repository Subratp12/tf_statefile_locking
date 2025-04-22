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