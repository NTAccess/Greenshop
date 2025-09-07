# AMI Ubuntu (latest 20.04 LTS)

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Bastion Host

resource "aws_instance" "VM_bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  private_ip    = "192.168.1.10"
  key_name      = aws_key_pair.bastion_key.key_name
  security_groups = [aws_security_group.bastion_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y && apt-get upgrade -y
              apt-get install -y ansible
              echo '${tls_private_key.admin.private_key_pem}' > /home/ubuntu/Admin-key.pem
              chmod 600 /home/ubuntu/Admin-key.pem
              reboot
              EOF

  tags = {
    Name        = "greenshop-Bastion"
    Role        = "Bastion"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}

# Load Balancer (VM version)

resource "aws_instance" "VM_Loadbalancer" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  private_ip    = "192.168.1.11"
  key_name      = aws_key_pair.admin_key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.internal_ssh_sg.id,
    aws_security_group.web_sg.id
  ]

  tags = {
    Name        = "greenshop-Loadbalancer"
    Role        = "LoadBalancer"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}

# Web Servers (Docker)

resource "aws_instance" "docker_vm_web" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
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
    Name        = "greenshop-web-${count.index+1}"
    Role        = "Web"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}

# MySQL Database

resource "aws_instance" "VM_mysql" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_db.id
  private_ip    = "192.168.20.14"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y mysql-server
              systemctl enable mysql
              systemctl start mysql
              EOF

  tags = {
    Name        = "greenshop-MySQL"
    Role        = "Database"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}

# Ansible VM

resource "aws_instance" "VM_ansible" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_app.id
  private_ip    = "192.168.10.20"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [aws_security_group.internal_ssh_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y ansible
              echo '${tls_private_key.admin.private_key_pem}' > /home/ubuntu/Admin-key.pem
              chmod 600 /home/ubuntu/Admin-key.pem             
              EOF

  tags = {
    Name        = "greenshop-Ansible"
    Role        = "ConfigMgmt"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}

# Jenkins VM

resource "aws_instance" "VM_jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_app.id
  private_ip    = "192.168.10.21"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id,
    aws_security_group.internal_ssh_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y openjdk-11-jdk wget gnupg
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
              sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              apt-get update -y
              apt-get install -y jenkins
              systemctl enable jenkins
              systemctl start jenkins
              EOF

  tags = {
    Name        = "greenshop-Jenkins"
    Role        = "CI/CD"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}

# Grafana + Prometheus VM

resource "aws_instance" "VM_monitoring" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_db.id
  private_ip    = "192.168.20.22"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [aws_security_group.internal_ssh_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io docker-compose
              systemctl start docker
              systemctl enable docker
              
              mkdir -p /opt/monitoring
              cat > /opt/monitoring/docker-compose.yml <<EOL
              version: '3'
              services:
                prometheus:
                  image: prom/prometheus
                  ports:
                    - "9090:9090"
                grafana:
                  image: grafana/grafana
                  ports:
                    - "3000:3000"
              EOL
              cd /opt/monitoring && docker-compose up -d
              EOF

  tags = {
    Name        = "greenshop-Monitoring"
    Role        = "Monitoring"
    Project     = "Greenshop"
    Environment = "Prod"
  }
}
