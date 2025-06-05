resource "aws_instance" "bastion" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.pub_1.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = true
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = {
      Name = "Bastion_server"
    }
}