variable "vpc_cidr" {
  type = string

}

variable "public_subnet_cidr" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "pvt_sub_cidr" {
  description = "List of private subnet CIDRs"
  type        = list(string)

}

variable "availability_zone" {
  description = "List of availability zones"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  type = bool

}

variable "aws_region" {
  type = string

}

variable "ami_id" {
  type = string

}
variable "instance_type" {
  type = string

}

variable "key_name" {
  type = string

}

variable "S3_bucket" {
  description = "S3 bucket name for storing files"
  type        = string
  default     = ""

}

# variable "route_cidr_block" {
#   description = "CIDR block for the default route in the route table"
#   type        = string
# }

# variable "route_table_name" {
#   description = "Name tag for the route table"
#   type        = string
# }

# Added Variables for Route Table Association
# variable "vpc_id" {
#   description = "ID of the VPC where the route table will be created"
#   type        = string
# }

# variable "gateway_id" {
#   description = "ID of the Internet Gateway to associate with the route table"
#   type        = string
# }

# variable "subnet_id" {
#   description = "ID of the subnet to associate with the route table"
#   type        = string
# }