locals {
  rules = {
    "my-ip" : {
      "name" : "synfwrule-${var.name}-${random_string.this.result}-test",
      "start_ip_address" : "195.114.146.141"
      "end_ip_address" : "195.114.146.141"
    }
  }
}