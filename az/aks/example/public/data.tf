data "template_file" "userdata" {
  template = file("${path.module}/cloud-init.yaml")

  vars = {
    K8S_VERSION = local.k8s_version
    ADMIN_USER  = local.linux_profile.default.admin_username
    K8S_CONFIG  = base64encode(module.aks.kube_config)
  }
}