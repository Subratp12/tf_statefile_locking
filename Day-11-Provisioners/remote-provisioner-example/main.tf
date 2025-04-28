# Define the AWS provider configuration
provider "aws" {
  region = "ap-south-1"  # Specify the AWS region
}

# Create an EC2 instance in AWS
resource "aws_instance" "TF_EC2" {
  ami           = "ami-0f1dcc636b69a6438"  # Amazon Linux 2 AMI ID (replace with the latest one for your region)
  instance_type = "t2.micro"
  key_name      = "AWScustomkey"  # Replace with your SSH key name
  tags = {
    Name = "Cust-EC2-Instance"  # Tag for the instance
  }
  
  # Connection details to access the EC2 instance
  connection {
    type        = "ssh"
    user        = "ec2-user"  # For Amazon Linux 2 AMI, the user is ec2-user
    private_key = file("~/.ssh/AWScustomkey.pem")  # Path to your private key
    host        = self.public_ip  # Use the instance's public IP to connect
  }

 # Remote-exec provisioner: Run commands on the EC2 instance
provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo yum install -y httpd",
    "sudo systemctl start httpd",
    "sudo systemctl enable httpd",
    "echo 'Hello from AWS!' | sudo tee /var/www/html/index.html"
  ]
}

}