output "proxy1_public_ip" {
  value = module.proxy1.instance_ip
}

output "proxy2_public_ip" {
  value = module.proxy2.instance_ip
}

output "be_ws1_private_ip" {
  value = module.be_ws1.instance_ip
}

output "be_ws2_private_ip" {
  value = module.be_ws2.instance_ip
}

output "public_alb_dns" {
  value = module.public_alb.alb_dns_name
}

output "internal_alb_dns" {
  value = module.internal_alb.alb_dns_name
}
