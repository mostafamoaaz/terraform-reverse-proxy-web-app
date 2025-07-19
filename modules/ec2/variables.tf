variable "vpc_id" {
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "ami_id" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the SSH private key (.pem)"
}

variable "is_public" {
  type        = bool
  description = "Whether the instance is in a public subnet and needs SSH access from the internet"
}

variable "ingress_ports" {
  type = list(number)
  description = "List of ports to allow in security group"
}
variable "run_provisioner" {
  type        = bool
  description = "Enable or disable remote-exec provisioner"
  default     = true
}


