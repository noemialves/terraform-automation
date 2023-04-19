provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "this" {
  engine = "mysql"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  username = "myuser"
  password = "mypassword"
  db_subnet_group_name = aws_db_subnet_group.main.name
  tags = {
    Name = "my-rds"
  }
}

resource "aws_db_subnet_group" "main" {
  name = "my-db-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_security_group_rule" "rds_ingress" {
  security_group_id = aws_db_instance.this.security_group_names[0]
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["${aws_security_group.lambda.id}/32"]
}
