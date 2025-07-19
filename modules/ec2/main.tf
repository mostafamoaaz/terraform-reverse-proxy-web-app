resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.is_public ? ["0.0.0.0/0"] : ["10.0.0.0/16"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = var.ssh_key_name

  associate_public_ip_address = var.is_public

  tags = {
    Name = var.instance_name
  }
}

resource "null_resource" "remote_provisioner" {
  count = var.run_provisioner ? 1 : 0

  provisioner "remote-exec" {
    inline = var.is_public ? [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "echo '<h1>${var.instance_name} (Nginx Proxy)</h1>' | sudo tee /var/www/html/index.html"
    ] : [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "echo '<h1>${var.instance_name} (Apache Backend)</h1>' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.is_public ? aws_instance.this.public_ip : aws_instance.this.private_ip
    }
  }

  depends_on = [aws_instance.this]
}
