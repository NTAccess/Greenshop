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
              echo '${tls_private_key.admin.private_key_pem}' > /home/ubuntu/Admin-key.pem
              chmod 600 /home/ubuntu/Admin-key.pem
              reboot
              EOF

  tags = {
    Name = "greenshop-Bastion"
  }
}

resource "aws_instance" "VM_Loadbalancer" {
  ami           = "ami-02029c87fa31fb148"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  private_ip    = "192.168.10.10"
  key_name      = aws_key_pair.admin_key.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

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
