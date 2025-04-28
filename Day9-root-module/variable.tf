variable "region" {
    type        = string
    description = "AWS region for the EC2 instance"
    default = ""
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = ""
}

variable "prevent_destroy" {
  description = "Lifecycle rule to prevent destruction"
  type        = bool
  default     = false  # Default value to false
}


variable "versioning_status" {
  description = "Versioning configuration for the S3 bucket"
  type        = string
    default     = "DISABLED"  # Default value to "Enabled"
}
