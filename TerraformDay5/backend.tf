terraform {
  backend "s3" {
    bucket = "sub12rat94"
    key    = "dev/terraform.tfstate"
    region = "ap-south-2"
  }
}