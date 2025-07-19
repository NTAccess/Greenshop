resource "aws_network_acl" "db_acl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.private.id] # le subnet où est ta base de données

  # Règle entrante : autorise le trafic TCP entrant sur le port 3306
  ingress {
    rule_no    = 100
    protocol   = "6"               # TCP
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3306
    to_port    = 3306
  }

  # Règle entrante : tout le reste est refusé
  ingress {
    rule_no    = 200
    protocol   = "-1"              # tous protocoles
    rule_action = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Règle sortante : tout est refusé
  egress {
    rule_no    = 100
    protocol   = "-1"              # tous protocoles
    rule_action = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "db-deny-egress-allow-3306"
  }
}
