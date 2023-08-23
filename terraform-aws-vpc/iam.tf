provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

# IAM Users
resource "aws_iam_user" "ec2_user" {
  name = "ec2-user"
}

resource "aws_iam_user" "rds_user" {
  name = "rds-user"
}

# IAM Policies
resource "aws_iam_policy" "ec2_policy" {
  name = "EC2Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::mys3bucket/*"]
      },
      {
        Action   = ["rds-db:connect"],
        Effect   = "Allow",
        Resource = ["arn:aws:rds-db:us-west-2:123456789012:dbuser:db-id/db-username"]
      },
      {
        Action   = ["rds:RestoreDBClusterFromS3", "rds:RestoreDBInstanceFromS3"],
        Effect   = "Allow",
        Resource = "*"
      }
      # Add more statements as needed for other permissions
    ],
  })
}

resource "aws_iam_policy" "rds_policy" {
  name = "RDSPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject"],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::mys3bucket/*"]
      },
      {
        Action   = ["ec2:DescribeInstances"],
        Effect   = "Allow",
        Resource = "*"
      }
      # Add more statements as needed for other permissions
    ],
  })
}

# IAM Roles
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

# IAM Role Policy Attachments
resource "aws_iam_policy" "rds_snapshot_policy" {
  name        = "rds-snapshot-policy"
  description = "Policy for RDS snapshot export to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::mys3bucket",
          "arn:aws:s3:::mys3bucket/*"
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

# IAM User Policy Attachments
resource "aws_iam_user_policy_attachment" "ec2_user_attachment" {
  user       = aws_iam_user.ec2_user.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_user_policy_attachment" "rds_user_attachment" {
  user       = aws_iam_user.rds_user.name
  policy_arn = aws_iam_policy.rds_policy.arn
}
