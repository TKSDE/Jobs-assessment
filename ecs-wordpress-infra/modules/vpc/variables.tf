variable "vpc_cidr" {
  description = "VPC ke liye CIDR block"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC ka naam"
  default     = "ecs-wordpress-vpc"
}

variable "public_subnets_cidr" {
  description = "Public subnets ke liye CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "Private subnets ke liye CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]  # Apne region ke hisaab se change karo
}
