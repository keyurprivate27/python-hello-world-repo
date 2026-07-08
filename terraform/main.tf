terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web_server" {
  ami             = "ami-0bc7aabcf58d1e02a"
  instance_type   = var.instance_type
  key_name        = "19-ec2-key"
  security_groups = [aws_security_group.ssh_sg.name]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "ssh_sg" {
  name        = "allow-ssh-sg"
  description = "Security group for SSH access"
  vpc_id      = "vpc-072ecce0544818d85" # Replace with your VPC ID

  tags = {
    Name = "allow-ssh-sg"
  }
}

# 2. Inbound Rule: Allow SSH (Port 22) from a specific IP range
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ssh_sg.id

  # ⚠️ Replace with your actual public IP or network (e.g., "203.0.113.50/32")
  cidr_ipv4 = "0.0.0.0/0" # Allowing SSH from anywhere (not recommended for production) 

  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
  description = "SSH access from trusted IP"
}

# 3. Outbound Rule: Allow all outbound traffic (Required for updates/packages)
resource "aws_vpc_security_group_egress_rule" "ssh_allow_all_egress" {
  security_group_id = aws_security_group.ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}