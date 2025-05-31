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
