# --------- PROVIDER ---------
provider "aws" {
  region = var.aws_region
}

# --------- DATA SOURCE FOR AMI ---------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# --------- NETWORK MODULE ---------
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  project_name         = var.project_name
}

# --------- EC2 PROXY 1 ---------
module "proxy1" {
  source           = "./modules/ec2"
  subnet_id        = module.network.public_subnet_ids[0]
  vpc_id           = module.network.vpc_id
  instance_name    = "proxy1"
  ami_id           = data.aws_ami.ubuntu.id
  ssh_key_name     = var.ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path
  is_public        = true
  run_provisioner     = true
  ingress_ports    = [22, 80]
}

# --------- EC2 PROXY 2 ---------
module "proxy2" {
  source           = "./modules/ec2"
  subnet_id        = module.network.public_subnet_ids[1]
  vpc_id           = module.network.vpc_id
  instance_name    = "proxy2"
  ami_id           = data.aws_ami.ubuntu.id
  ssh_key_name     = var.ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path
  is_public        = true
  run_provisioner     = true
  ingress_ports    = [22, 80]
}

# --------- EC2 BE-WS1 ---------
module "be_ws1" {
  source           = "./modules/ec2"
  subnet_id        = module.network.private_subnet_ids[0]
  vpc_id           = module.network.vpc_id
  instance_name    = "be-ws1"
  ami_id           = data.aws_ami.ubuntu.id
  ssh_key_name     = var.ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path
  is_public        = false
  run_provisioner     = false
  ingress_ports    = [80, 22]
}

# --------- EC2 BE-WS2 ---------
module "be_ws2" {
  source           = "./modules/ec2"
  subnet_id        = module.network.private_subnet_ids[1]
  vpc_id           = module.network.vpc_id
  instance_name    = "be-ws2"
  ami_id           = data.aws_ami.ubuntu.id
  ssh_key_name     = var.ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path
  is_public        = false
  run_provisioner     = false
  ingress_ports    = [80, 22]
}

# --------- PUBLIC ALB (Internet to Proxies) ---------
module "public_alb" {
  source              = "./modules/alb"
  name                = var.public_alb_name
  is_internal         = false
  subnet_ids          = module.network.public_subnet_ids
  vpc_id              = module.network.vpc_id
  target_instance_ids = [module.proxy1.instance_id, module.proxy2.instance_id]
  port                = 80
  ingress_cidrs       = ["0.0.0.0/0"]
}

# --------- INTERNAL ALB (Proxies to Backend) ---------
module "internal_alb" {
  source              = "./modules/alb"
  name                = var.internal_alb_name
  is_internal         = true
  subnet_ids          = module.network.private_subnet_ids
  vpc_id              = module.network.vpc_id
  target_instance_ids = [module.be_ws1.instance_id, module.be_ws2.instance_id]
  port                = 80
  ingress_cidrs       = ["10.0.0.0/16"] # adjust later if needed
}
