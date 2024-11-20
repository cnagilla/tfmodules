locals {
  ifconfig_co_json = jsondecode(data.http.public_ip.body)
}