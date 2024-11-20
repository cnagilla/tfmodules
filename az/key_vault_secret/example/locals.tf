locals {
  secrets = {
    "db_user" : {
      "key" : "DatabaseUserName",
      "value" : "sysops"
    },
    "db_password" : {
      "key" : "DatabaseUserPassword",
      "value" : random_string.this.result
    }
  }
}