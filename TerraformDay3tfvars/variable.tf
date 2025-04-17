variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = ""
  
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
  default     = "" # Replace with a valid AMI ID for ap-south-1
  
}

variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = string
  default     = ""
  
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance."
  type        = string
  default    = ""
  
}

variable "bucket_name" {
 description = "The name of the S3 bucket to create."
  type        = string
  default     = ""
  
}