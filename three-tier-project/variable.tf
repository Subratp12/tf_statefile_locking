# VPC
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnets
variable "public_subnets" {
  description = "VPC CIDR"
  type        = map(string)
  default = {
    pub_1 = "10.0.1.0/24"
    pub_2 = "10.0.2.0/24"
  }
}

# Private Subnets
variable "private_subnets" {
  description = "VPC CIDR"
  type        = map(string)
  default = {
    pvt_1 = "10.0.3.0/24"
    pvt_2 = "10.0.4.0/24"
    pvt_3 = "10.0.5.0/24"
    pvt_4 = "10.0.6.0/24"
    pvt_5 = "10.0.7.0/24"
    pvt_6 = "10.0.8.0/24"
  }
}

# ami for ec2
variable "ami" {
  description = "ami for ec2"
  type        = string
  default     = "ami-0e35ddab05955cf57" #ubuntu ami
}

# instance type
variable "instance_type" {
  description = "instance type for ec2"
  type        = string
  default     = "t2.micro"
}

variable "db_username" {
  description = "The username of the database"
  type        = string
  default     = "admin"
  sensitive   = true
}
variable "db_password" {
  description = "The password of the database"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "key_name" {
  type    = string
  default = "AWScustomkey"

}