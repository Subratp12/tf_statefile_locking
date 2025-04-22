resource "aws_instance" "ec2" {
  ami           = "ami-05cef57fad40b2755"
  instance_type = "t3.micro"
  key_name      = "AWS_hyd"
}