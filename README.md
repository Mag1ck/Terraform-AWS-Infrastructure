# Terraform AWS Web Server Deployment

## Overview
Automated infrastructure deployment using Terraform and LocalStack. This project demonstrates Infrastructure as Code principles by deploying a complete web application stack.

## Architecture
- **VPC**: Custom virtual private cloud (10.0.0.0/16)
- **Public Subnet**: us-east-1a with internet access
- **EC2 Instance**: t2.micro running Apache HTTP Server
- **Security Group**: Configured for HTTP traffic (port 80)
- **User Data**: Automated server configuration script

## Prerequisites
- Terraform >= 1.0
- Docker Desktop (for LocalStack)
- AWS CLI

## Usage

### Start LocalStack
```bash
docker run -d -p 4566:4566 localstack/localstack
```

### Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

## Project Structure
```
.
├── main.tf           # Main infrastructure configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Output definitions
└── README.md         # This file
```

## Technologies Used
- Terraform
- AWS (VPC, EC2, Security Groups)
- LocalStack (local AWS simulation)
- Apache HTTP Server
- Bash scripting

## Skills Demonstrated
- Infrastructure as Code (IaC)
- Cloud architecture design
- Network security configuration
- Configuration management
- DevOps automation practices
