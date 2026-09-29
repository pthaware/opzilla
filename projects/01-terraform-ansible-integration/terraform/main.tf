terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


variable "instance_count" {
  default = 3
}


resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for webserver instances"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-sg"
  }
}


resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = file("/home/ubuntu/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web_servers" {
  count                  = var.instance_count
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.ansible.key_name
  tags = {
    Name = "web-server-${count.index + 1}"
  }
}


resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/hosts.ini"
  content = <<-EOF
[webservers]
%{ for index, server in aws_instance.web_servers ~}
web${index + 1} ansible_host=${server.public_ip} ansible_user=ubuntu
%{ endfor ~}
EOF
}
