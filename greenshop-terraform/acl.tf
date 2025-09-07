resource "aws_network_acl" "db_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private_db.id]

  ingress {
    rule_no    = 100
    protocol   = "6"
    cidr_block = "192.168.10.0/24"
    from_port  = 3306
    to_port    = 3306
    action     = "allow"
  }

  ingress {
    rule_no    = 200
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    action     = "deny"
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    action     = "allow}"
  }

  tags = {
    Name = "greenshop-db-acl"
  }
}
