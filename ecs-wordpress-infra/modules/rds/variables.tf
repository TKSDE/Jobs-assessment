# modules/rds/variables.tf
variable "db_security_group_id" {
  description = "The ID of the security group for RDS"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets for RDS"
  type        = list(string)
}
