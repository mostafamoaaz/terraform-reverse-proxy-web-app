variable "aws_region" {
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "project_name" {
  type = string
}

variable "ssh_key_name" {
  type = string
}
variable "ssh_private_key_path" {
  type        = string
}
variable "public_alb_name" {
  type        = string
  description = "Name of the public ALB"
}

variable "internal_alb_name" {
  type        = string
  description = "Name of the internal ALB"
}