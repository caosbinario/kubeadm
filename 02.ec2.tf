#######  resource ####### 
resource "aws_instance" "kubeadm" {
  count         = 3
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
          #!/bin/bash

          # updates
          dnf makecache --refresh
          dnf update -y
          sudo yum update -y
          EOF

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  key_name = aws_key_pair.kubeadm-ssh.key_name

  vpc_security_group_ids = [
    aws_security_group.kubeadm-sg.id
  ]

  tags = {
    Name        = "${var.server_name}-${count.index + 1}"
    Environment = var.environment
    Owner       = "ariel.molina@caosbinario.com"
    Team        = "DevOps"
    Project     = "kubeadm"
  }
}