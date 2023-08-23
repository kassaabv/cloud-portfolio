provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_az1.id  # Replace with the desired subnet ID from vpc.tf

  tags = {
    Name = "MyEC2Instance"
  }
}
