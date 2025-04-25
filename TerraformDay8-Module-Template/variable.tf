variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instance"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the VPC"
  type        = list(string)
}

variable "availability_zone" {
  description = "The availability zone to create resources in"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "pvt_subnet_cidr" {
  description = "The CIDR block for the VPC"
  type        = list(string)
}

variable "security_group_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "TF_SG"
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


variable "bucket_suffix_length" {
  description = "Length of the random string for the bucket suffix"
  type        = number
  default     = 15
}

variable "bucket_suffix_special" {
  description = "Whether to include special characters in the random string for the bucket suffix"
  type        = bool
  default     = false
}



variable "s3_acl" {
  description = "Canned ACL to apply to the S3 bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "tf-subrat-bucket-1234567890"  
}