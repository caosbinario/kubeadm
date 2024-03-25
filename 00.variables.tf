####### Variables #######

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  default     = "ami-0fe630eb857a6ec83"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t3.medium"
}

variable "server_name" {
  description = "Nombre del servidor web"
  default     = "kubeadm"
}

variable "environment" {
  description = "Ambiente de la aplicación"
  default     = "test"
}