


##-----------------------S3 Bucket-----------------------
module "S3" {
  source = "./submodule/s3"

  bucket_name      = "sub12rat94"
  versioning_status = "Enabled"  # Can be "Enabled" or "Suspended"
  prevent_destroy  = true
  region           = "ap-south-1"
}




