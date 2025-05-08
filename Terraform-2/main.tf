resource "aws_instance" "cust_ec2" {
  ami           = "ami-062f0cc54dbfd8ef1"  # Replace with a valid AMI ID for ap-south-1
  instance_type = "t2.micro"
  key_name      = "AWScustomkey"
tags = {
  Name = "Cust-EC2"
  }

}

#resource "aws_instance" "ec2_import" {
 # ami           = "ami-002f6e91abff6eb96"
  #instance_type = "t2.micro"
 # key_name      = "AWScustomkey"
#}
