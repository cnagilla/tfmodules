module "password" {
  source = "../../password"

  length           = 16
  override_special = "!#&%"
}