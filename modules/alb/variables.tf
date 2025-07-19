variable "name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "is_internal" {
  type        = bool
  description = "Whether ALB is internal or public"
}

variable "target_instance_ids" {
  type = list(string)
}

variable "port" {
  type        = number
  description = "Listener port"
}

variable "protocol" {
  type        = string
  default     = "HTTP"
}

variable "ingress_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
