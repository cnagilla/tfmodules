locals {
  arm_template_params = jsonencode({
    "vnetName" = {
      value = "${var.name}-${random_string.this.result}"
    }
  })
  arm_template = file("./templates/vnet.json")
}