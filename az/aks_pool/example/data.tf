data "template_file" "userdata" {
  template = file("${path.module}/cloud-init.yaml")

  vars = {
    K8S_VERSION = local.k8s_version
    ADMIN_USER  = local.ssh_user
    K8S_CONFIG  = base64encode(azurerm_kubernetes_cluster.this.kube_config_raw)
  }
}