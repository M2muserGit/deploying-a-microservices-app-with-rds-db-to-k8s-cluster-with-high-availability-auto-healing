provider "aws" {
  region = "us-west-2"
}
resource "aws_security_group" "db" {
  name        = "db_sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7.44"
  instance_class       = "db.t3.micro" # Free tier class
  #name                 = "petclinic"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.db.id]
}

output "db_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.default.endpoint
