provider "aws" {
  region = "us-east-1"  # Update to your preferred region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "MyVPC"
  public_subnets_cidr = ["10.0.1.0/24"]
  private_subnets_cidr = ["10.0.2.0/24"]
  azs = ["us-east-1a", "us-east-1b"]
}

module "rds" {
  source = "./modules/rds"
  db_username          = var.db_username  # Replace with your username
  db_password          = var.db_password # Replace with your password
  db_security_group_id = module.vpc.rds_security_group_id  # Reference security group
  private_subnets      = [module.vpc.private_subnets[*]]  # Pass private subnets
}

module "secretmanager" {
  source = "./modules/secretmanager"
  db_username = module.rds.db_instance_endpoint  # Correctly reference username
  db_password = random_password.rds_password.result  # Ensure password is generated
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}
