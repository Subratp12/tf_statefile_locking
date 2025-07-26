terraform {
  backend "s3" {
    bucket         = "subpad-bucket"
    key            = "terraform/state/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "SubratDynamoDBTable"
    encrypt        = true
  }
}
