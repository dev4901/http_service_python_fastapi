provider "aws" {
  region = "us-east-2" # Change to your preferred region
}

# IAM Role for EC2 with S3 Read-Only Access
resource "aws_iam_role" "ec2_role" {
  name = "EC2S3ReadOnlyRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach S3 ReadOnly Policy to the IAM Role
resource "aws_iam_policy_attachment" "s3_readonly_attachment" {
  name       = "s3-readonly-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# IAM Instance Profile (needed to attach IAM Role to EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# Security Group for EC2
resource "aws_security_group" "fastapi_sg" {
  name        = "fastapi-sg"
  description = "Allow SSH and FastAPI traffic"

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to restrict access
  }

  # Allow FastAPI (port 8000)
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (adjust for security)
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for FastAPI
resource "aws_instance" "fastapi_ec2" {
  ami                  = "ami-07f463d9d4a6f005f" # Use latest Amazon Linux 2 AMI for your region
  instance_type        = "t2.micro"
  key_name             = "lin-pwd" # Replace with your actual EC2 key pair
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups      = [aws_security_group.fastapi_sg.name]
  user_data            = file("userdata.sh") # Runs the script on startup

  tags = {
    Name = "FastAPI-Server"
  }
}

# Output the EC2 public IP
output "public_ip" {
  value = aws_instance.fastapi_ec2.public_ip
}
