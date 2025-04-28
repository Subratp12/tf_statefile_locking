# Define the AWS provider configuration.
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region.
}


resource "aws_key_pair" "example" {
  key_name   = "USkey" # <-- Your desired key name
  public_key = file("~/.ssh/id_ed25519.pub")
}


# resource "aws_vpc" "myvpc" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "sub1" {
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = "10.0.0.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.myvpc.id
# }

# resource "aws_route_table" "RT" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "rta1" {
#   subnet_id      = aws_subnet.sub1.id
#   route_table_id = aws_route_table.RT.id
# }

# resource "aws_security_group" "webSg" {
#   name   = "web"
#   vpc_id = aws_vpc.myvpc.id

#   ingress {
#     description = "HTTP from VPC"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Web-sg"
#   }
# }

resource "aws_instance" "server" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name


  connection {
    type = "ssh"
    user = "ubuntu" # Replace with the appropriate username for your EC2 instance
    # private_key = file("C:/Users/veerababu/.ssh/id_rsa")
    private_key = file("~/.ssh/id_ed25519")
    host        = self.public_ip
  }
provisioner "local-exec" {
  command = "touch file500 && echo 'hello from aws' >> file500"
}

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "file10"              # Replace with the path to your local file
    destination = "/home/ubuntu/file10" # Replace with the path on the remote instance
  }
  # remote execution process 
  provisioner "remote-exec" {
    inline = [
      "touch file200",
      "echo hello from aws >> file200", ##mysql -h -u user -p
    ]
  }
}

 