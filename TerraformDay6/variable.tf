variable "aws_region" {
  description = "AWS Region for the infrastructure"
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = ""
}

variable "subnet_cidrs" {
  description = "CIDR blocks for public and private subnets"
  default = {
    "public"  = ""
    "private" = ""
  }
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  default = {
    "public"  = ""
    "private" = ""
  }
}

variable "key_name" {
  description = "SSH Key pair name for EC2 instance"
  default     = ""
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "" # Example AMI ID, replace with a valid one 

}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = ""

}