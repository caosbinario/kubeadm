####### SG ####### 
resource "aws_security_group" "kubeadm-sg" {
  name        = "${var.server_name}-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.server_name}-sg"
    Environment = "${var.environment}"
    Owner       = "ariel.molina@caosbinario.com"
    Team        = "DevOps"
    Project     = "kubeadm"
  }
}