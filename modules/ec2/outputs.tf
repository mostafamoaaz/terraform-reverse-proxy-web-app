output "instance_id" {
  value = aws_instance.this.id
}

output "instance_ip" {
  value = var.is_public ? aws_instance.this.public_ip : aws_instance.this.private_ip
}

output "sg_id" {
  value = aws_security_group.this.id
}
