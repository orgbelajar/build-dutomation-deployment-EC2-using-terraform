provider "aws" {
  region = var.aws_region
}

# Ambil AMI Amazon Linux 2023 (x86_64)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # AWS Amazon Linux

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Buat Key Pair dari public key lokal
resource "aws_key_pair" "ci" {
  key_name   = "test-tf-key"
  public_key = file(var.ssh_key_public_path)
}

# Security Group: HTTP (80) terbuka, SSH (22) dibatasi (atau 0.0.0.0/0 untuk demo)
resource "aws_security_group" "web" {
  name        = "test-tf-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-tf-sg"
  }
}

# Ambil VPC default & subnet default
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# User data: pasang httpd, clone repo, copy test.html jadi index.html
locals {
  bootstrap = <<-EOF
    #!/bin/bash
    set -e

    dnf update -y
    dnf install -y httpd git

    systemctl enable --now httpd

    mkdir -p /var/www/html/site
    cd /var/www/html

    git config --global --add safe.directory /var/www/html/site || true

    # Clone repo public; jika private, ganti pakai token atau deploy key
    if [ ! -d "/var/www/html/site/.git" ]; then
      git clone ${var.repo_url} site
    fi

    # Sajikan test.html sebagai halaman root
    cp -f /var/www/html/site/test.html /var/www/html/index.html
    chmod 644 /var/www/html/index.html

    systemctl restart httpd
  EOF
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ci.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  user_data = local.bootstrap

  tags = {
    Name = "test-tf-ec2"
  }
}
