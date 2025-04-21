variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = ""
  
}

variable "ami_id" {
    type = string
    description = "The AMI ID to use for the EC2 instance"
  default = ""
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = ""
  
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default    = ""
  
}