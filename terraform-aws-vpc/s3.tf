provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
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

resource "aws_s3_bucket_policy" "mys3bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id  # Reference the created S3 bucket
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        },
        Resource = [
          "${aws_s3_bucket.my_bucket.arn}",
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ],
  })
}
