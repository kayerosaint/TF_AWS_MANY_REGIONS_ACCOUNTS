// many users

variable "aws_users" {
  description = "List of IAM Users to create"
  default     = ["Maksim", "Aynur", "Donald", "Byden", "Putin", "Galkin", "John", "Mariah"]
}

//ports

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

//groups policies

variable "group_dev" {
  default = "dev"
}

variable "group_prod" {
  default = "prod"
}

variable "ec2_size" {
  default = {
    "dev"  = "t3.medium"
    "prod" = "t3.micro"
  }
}
