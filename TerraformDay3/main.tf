resource "aws_instance" "tf_ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
}