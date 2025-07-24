variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "admin"  # Optional: set a default or pass via env
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "Subnet group name to place RDS in"
  type        = string
}