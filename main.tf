terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3 = "http://localhost:4566"
    rds = "http://localhost:4566"
  }
}
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "my-kozacki-vpc"
    Environment = "learning"
  }
}

resource "aws_security_group" "web_sg" {
  name = "web-server-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP from Internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-server-sg"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet"
    Type = "Public"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello from Terraform! Deployed by me (Mag1ck)</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "my-web-server"
    Role = "WebServer"
  }
}

output "test_vpc_id" {
  description = "The ID of our VPC"
  value       = aws_vpc.main.id
}

output "test_subnet_id" {
  description = "The ID of our subnet"
  value       = aws_subnet.public.id
}

output "instance" {
  description = "The id of our instance"
  value       = aws_instance.web.id
}

output "web_server_url" {
  description = "URL to access the web server"
  value = "http://${aws_instance.web.public_ip}"
}
