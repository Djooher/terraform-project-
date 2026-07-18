provider "aws" {
  region = "us-east-1"

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}


# Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production"
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "production"
  }
}


# Create Route Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod"
  }
}


# Create Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}


# Associate subnet with route table
resource "aws_route_table_association" "route_table" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}


# Create Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_web"
  }
}


# Create Network Interface
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}


# Assign Elastic IP
resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.test.id
  associate_with_private_ip = "10.0.1.50"
}


# Create EC2 instance
resource "aws_instance" "web-server-instance" {
  ami               = "ami-12345678"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.test.id
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install apache2 -y
              systemctl start apache2
              echo "your very first web server" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server"
  }
}


# Outputs
output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip
}


output "server_id" {
  value = aws_instance.web-server-instance.id
}
