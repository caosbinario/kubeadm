####### ssh ####### 
# ssh-keygen -t rsa -b 2048 -f "kubeadm.key"

resource "aws_key_pair" "kubeadm-ssh" {
  key_name   = "${var.server_name}-ssh"
  public_key = file("${var.server_name}.key.pub")

  tags = {
    Name        = "${var.server_name}-ssh"
    Environment = "${var.environment}"
    Owner       = "ariel.molina@caosbinario.com"
    Team        = "DevOps"
    Project     = "webinar"
  }
}