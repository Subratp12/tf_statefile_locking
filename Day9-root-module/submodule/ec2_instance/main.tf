provider "aws" {
  region = var.country
}

resource "aws_instance" "TF_EC2" {
  ami           = var.ami # Amazon Linux 2 AMI
  instance_type = var.type_instance
  key_name      = var.key
}
