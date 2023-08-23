output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_az1_id" {
  description = "ID of the created public subnet AZ1"
  value       = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  description = "ID of the created public subnet AZ2"
  value       = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_az1_id" {
  description = "ID of the created private app subnet AZ1"
  value       = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  description = "ID of the created private app subnet AZ2"
  value       = aws_subnet.private_app_subnet_az2.id
}

output "private_data_subnet_az1_id" {
  description = "ID of the created private data subnet AZ1"
  value       = aws_subnet.private_data_subnet_az1.id
}

output "private_data_subnet_az2_id" {
  description = "ID of the created private data subnet AZ2"
  value       = aws_subnet.private_data_subnet_az2.id
}

output "rds_instance_endpoint" {
  description = "Endpoint of the created RDS instance"
  value       = aws_db_instance.mysql_rds.endpoint
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}
