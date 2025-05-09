provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "Bastion-key"
  public_key = tls_private_key.bastion.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.bastion.private_key_pem}' > ./Bastion-key.pem"
  }
}

resource "tls_private_key" "admin" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "admin_key" {
  key_name   = "Admin"
  public_key = tls_private_key.admin.public_key_openssh
}

resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "greenshop-vpc" }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "greenshop-public-subnet" }
}

resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 10)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "greenshop-private-app" }
}

resource "aws_subnet" "private_db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 20)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "greenshop-private-db" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_app_assoc" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_db_assoc" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "greenshop-bastion-sg"
  description = "Allow SSH from trusted IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.208.180.42/32", "77.132.122.218/32", "92.161.164.161/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name   = "greenshop-web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name   = "greenshop-db-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_ssh_sg" {
  name   = "greenshop-internal-ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "greenshop-ssh-from-bastion"
  }
}

resource "aws_instance" "VM-bastion" {
  ami                    = "ami-0f9de6e2d2f067fca"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "192.168.1.10"
  key_name               = aws_key_pair.bastion_key.key_name
  security_groups        = [aws_security_group.bastion_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y && apt-get upgrade -y
              apt-get install -y ansible
              echo '${tls_private_key.admin.private_key_pem}' > /home/ubuntu/Admin.key.pem
              chmod 600 /home/ubuntu/Admin.key.pem
              reboot
              EOF

  tags = {
    Name = "greenshop-Bastion"
  }
}

resource "aws_instance" "VM_Loadbalancer" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  private_ip    = "192.168.1.20"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "greenshop-Loadbalancer"
  }
}

resource "aws_instance" "docker_vm_web" {
  count         = 3
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_app.id
  key_name      = aws_key_pair.admin_key.key_name
  private_ip    = cidrhost(aws_subnet.private_app.cidr_block, 11 + count.index)

  vpc_security_group_ids = [
    aws_security_group.web_sg.id,
    aws_security_group.internal_ssh_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io openssh-server
              systemctl start docker
              EOF

  tags = {
    Name = "servweb-${count.index+1}"
  }
}

resource "aws_instance" "VM_mariaDB" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_db.id
  private_ip    = "192.168.20.14"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              sudo apt install mariadb-server
              EOF

  tags = {
    Name = "greenshop-mariaDB"
  }
}
