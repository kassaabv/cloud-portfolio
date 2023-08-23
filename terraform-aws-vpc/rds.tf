provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = ["subnet-example1", "subnet-example2"]  
}

resource "aws_db_instance" "mysql_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "examplepassword"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  s3_import {
    bucket_name = aws_s3_bucket.my_bucket.id
    bucket_prefix = "rds-snapshots/"
  }

  tags = {
    Name = "ExampleMySQLRDSInstance"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"

  # Inbound rule to allow MySQL traffic from specific sources
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.10/32"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mys3bucket"  # Replace with your desired bucket name
  acl    = "private"

  versioning {
    enabled = true 
  }

  tags = {
    Name = "MyS3Bucket"
  }
}
