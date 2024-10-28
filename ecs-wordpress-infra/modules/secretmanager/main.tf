resource "aws_secretsmanager_secret" "rds_db" {
  name        = "rds_db_secret"
  description = "RDS MySQL database credentials"
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_db.id
  secret_string = jsonencode({
    username = var.db_username       # Use variable for username
    password = var.db_password       # Use variable for password
  })
}
