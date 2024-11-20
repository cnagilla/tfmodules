locals {
  k8s_version    = "1.25.5"
  ssh_user       = "sysops"
  ssh_public_key = tls_private_key.ssh.public_key_openssh
}