provider "aws" {
  region = "ap-south-1"
  
}

resource "aws_instance" "example" {
  ami           = "ami-0f1dcc636b69a6438"
  instance_type = "t2.micro"
    key_name      = "AWScustomkey"
    tags = {
        Name = "Cust-EC2"
        }
  
  provisioner "local-exec" {
    command = "echo 'This is a local execution example'.Instance public IP is ${self.public_ip} > example.txt"
  }
}
