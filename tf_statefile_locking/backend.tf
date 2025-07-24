terraform {
  backend "s3" {
    bucket         = "terraform-collab-state"       # Your shared S3 bucket name
    key            = "amazon-team/infra.tfstate"    # Path to the state file in the bucket
    region         = "ap-south-1"                   # AWS region of the bucket and DynamoDB table
    dynamodb_table = "terraform-collab-lock"        # Table used for state locking
    encrypt        = true                           # Server-side encryption for the state file
  }
}