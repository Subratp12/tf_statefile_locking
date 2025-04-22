terraform {
  backend "s3" {
    bucket = "sub12rat94"
    key    = "test1/terraform.tfstate"
    region = "ap-south-2"
  }
}
