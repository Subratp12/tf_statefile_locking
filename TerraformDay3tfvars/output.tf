output "ami_id" {
  value = aws_instance.EC2.ami
  
}

output "instance_type" {
  value = aws_instance.EC2.instance_type
  
}
output "key_name" {
  value = aws_instance.EC2.key_name
  
}
output "region" {
  value = aws_instance.EC2.availability_zone
  
}
output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
  
}
output "instance_id" {
  value = aws_instance.EC2.id
  
}
output "instance_public_ip" {
  value = aws_instance.EC2.public_ip
  
}   
output "instance_private_ip" {
  value = aws_instance.EC2.private_ip
  sensitive = true
  
}
output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
  
}