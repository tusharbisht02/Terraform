resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "nginx" {
  ami                    = "ami-0c02fb55956c7d316" # Ubuntu 20.04 LTS (for us-east-1)
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "nginx-instance"
  }
}

