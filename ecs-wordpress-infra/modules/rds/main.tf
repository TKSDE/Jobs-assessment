resource "aws_db_instance" "rds_db" {
  identifier         = "mydb"
  allocated_storage   = 20
  storage_type       = "gp2"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t2.micro"
  username           = var.db_username
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.db_security_group_id]  # Updated
  multi_az           = false
  tags = {
    Name = "RDS Instance"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnets  # Pass private subnets as variable
  tags = {
    Name = "RDS Subnet Group"
  }
}

# Outputs for RDS
output "db_instance_endpoint" {
  value = aws_db_instance.rds_db.endpoint
}
