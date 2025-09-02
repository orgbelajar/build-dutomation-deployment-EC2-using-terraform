variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2" # ganti ke ap-southeast-3 bila ingin Jakarta
}

variable "instance_type" {
  type        = string
  default     = "t3.micro" # free-tier friendly (t2.micro juga bisa)
}

variable "repo_url" {
  type        = string
  description = "URL Git repository yang berisi challenge.html"
  default     = "https://github.com/orgbelajar/build-dutomation-deployment-EC2-using-terraform.git"
}

variable "ssh_key_public_path" {
  type        = string
  default     = "keys/test_tf.pub"
}

# OPTIONAL: batasi IP SSH-mu (ganti 0.0.0.0/0 jadi IP publik kamu)
variable "ssh_ingress_cidr" {
  type        = string
  default     = "0.0.0.0/0"
}
