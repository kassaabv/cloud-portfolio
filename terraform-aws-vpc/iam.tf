provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_iam_user" "example_user" {
  name = "example-user"
}

resource "aws_iam_policy" "example_policy" {
  name = "ExamplePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:ListBucket"],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::mys3bucket"
      },
      {
        Action   = ["s3:GetObject"],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::mys3bucket/*"
      }
    ],
  })
}

resource "aws_iam_user_policy_attachment" "example_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_s3_bucket" "mys3bucket" {
  bucket = "mys3bucket"  # Replace with your S3 bucket name
  acl    = "private"     # You can set the bucket ACL to private, public-read, etc.

  # Other bucket settings...
}

resource "aws_iam_role" "rds_snapshot_role" {
  name = "rds-snapshot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "rds_snapshot_policy" {
  name        = "rds-snapshot-policy"
  description = "Policy for RDS snapshot export to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.mys3bucket.arn,
          "${aws_s3_bucket.mys3bucket.arn}/*"
        ]
      }
    ],
  })
}

resource "aws_iam_policy_attachment" "rds_snapshot_policy_attachment" {
  name       = "rds-snapshot-policy-attachment"
  roles      = [aws_iam_role.rds_snapshot_role.name]
  policy_arn = aws_iam_policy.rds_snapshot_policy.arn
}
