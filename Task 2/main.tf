provider "aws" {
  region = var.aws_region
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "app_sg" {
  name        = "app2-sg"
  description = "Allow SSH, Frontend, Backend"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Backend EC2 (Flask)

resource "aws_instance" "backend" {
  ami                    = "ami-0ced6a024bb18ff2e" # Amazon Linux 2 (ap-south-1)
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = file("user-data-backend.sh")

  tags = {
    Name = "Task2-Flask-Backend"
  }
}


# Frontend EC2 (Express)

resource "aws_instance" "frontend" {
  ami                    = "ami-0ced6a024bb18ff2e" # Amazon Linux 2 (ap-south-1)
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = templatefile("user-data-frontend.sh", {
    backend_private_ip = aws_instance.backend.private_ip
  })
  tags = {
    Name = "Task2-Express-Frontend"
  }
}
