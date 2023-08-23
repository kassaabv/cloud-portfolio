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
        Action = ["s3:ListBucket"],
        Effect = "Allow",
        Resource = "arn:aws:s3:::mys3bucket"
      },
      {
        Action = ["s3:GetObject"],
        Effect = "Allow",
        Resource = "arn:aws:s3:::mys3bucket/*"
      }
    ],
  })
}

resource "aws_iam_user_policy_attachment" "example_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.example_policy.arn
}
