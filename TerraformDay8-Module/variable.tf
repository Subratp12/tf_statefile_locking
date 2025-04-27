variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = ""
}

variable "S3_bucket" {
  description = "Name of the S3 bucket"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = ""
  
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = ""

  
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
  default = ""
}