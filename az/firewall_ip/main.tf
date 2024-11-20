resource "null_resource" "fw_ip" {
  triggers = {
    firewall_name  = var.firewall_name
    public_ip      = var.public_ip_name
    resource_group = var.resource_group_name
    vnet           = var.vnet_name != "" ? "--vnet-name ${var.vnet_name}" : ""
    subscription   = var.subscription
  }

  provisioner "local-exec" {
    command = <<-EOT
      az network firewall ip-config create ${self.triggers.vnet} --firewall-name ${self.triggers.firewall_name} \
                                           --name ${self.triggers.public_ip} \
                                           --public-ip-address ${self.triggers.public_ip} \
                                           --resource-group ${self.triggers.resource_group} \
                                           --subscription ${self.triggers.subscription}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      az network firewall ip-config delete --firewall-name ${self.triggers.firewall_name} \
                                           --name ${self.triggers.public_ip} \
                                           --resource-group ${self.triggers.resource_group} \
                                           --subscription ${self.triggers.subscription}
    EOT
  }
}