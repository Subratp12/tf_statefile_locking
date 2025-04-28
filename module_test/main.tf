module "test" {
  source                  = "../Module"                 # Path to the module directory
  aws_region              = var.aws_region              # AWS region to use
  ami_id                  = var.ami_id                  # AMI ID for the instance
  instance_type           = var.instance_type           # Instance type for the EC2 instance
  key_name                = var.key_name                # Key pair name for SSH access
  vpc_cidr                = var.vpc_cidr                # CIDR block for the VPC
  public_subnet_cidr      = var.public_subnet_cidr      # CIDR block for the public subnet
  availability_zone       = var.availability_zone       # Availability zone for the public subnet
  map_public_ip_on_launch = var.map_public_ip_on_launch # Map public IP on launch}
  pvt_sub_cidr            = var.pvt_sub_cidr        # CIDR block for the private subnet
  versioning_status       = var.versioning_status # Versioning configuration for the S3 bucket
  S3_bucket               = var.S3_bucket         # Name of the S3 bucket
  prevent_destroy         = var.prevent_destroy   # Lifecycle rule to prevent bucket destruction
}










