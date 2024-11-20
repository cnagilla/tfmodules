locals {
  virtual_machines = {
    "windows" : {
      "name" : "vmwin${var.name}",
      "os_family" : "windows",
      "admin_username" : "sysops",
      "admin_password" : random_password.windows.result,
      "image" : {
        "publisher" : "MicrosoftWindowsServer",
        "offer" : "WindowsServer",
        "sku" : "2019-Datacenter",
        "version" : "latest"
      },
      "disk" : {
        "name" : "disk-vmwindows${var.name}${random_string.this.result}"
        "storage_account_type" : "Standard_LRS",
        "caching" : "ReadWrite",
        "disk_size_gb" : 150
      },
      "nic" : {
        "default" : {
          "name" : "nic-vmwindows${var.name}${random_string.this.result}",
          "ip_configuration" : {
            "primary" : {
              "private_ip_address_allocation" : "Dynamic",
              "subnet_id" : azurerm_subnet.vm.id,
              "primary" : true
            }
          }
        }
      }
    },
    "linux" : {
      "name" : "vmlinux${var.name}",
      "os_family" : "linux",
      "admin_username" : "sysops",
      "admin_public_key" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIB6sSBzkec8QhrkL7i91hiqQtN7Vmfh9OYvvYXS/3myDo0E3FaWZKqFs4JFAUynze9EPlKY7yZdE1NIFZGlVP4+a9v0uSQ2y/MB/GmVQ/afQ8yYlLTEL4zYZ5a0N736lz4bXhb0eCYkMN/Tgrqo1/6b3EjS9zIQAdZD8f6uG0HBxWTaKvuDRrhlMT1c7S9rFLog2vIC/LMxHABaVPOCP38+VCoS4Iq3RCs3B/hZ8hogKHtnxwNE83CrCDH4SJ6nf9eKtj2PQXRbX9LbKcgRXwIHDzuO7CZ1VVexF6DMaRb6Xs+ADYr4QVtvZtbp2hq7ldx/cGRHPpjlkx4dpYPtX1K54EGrO45DSFYfA99VU2q0I56Af6kHUGHqJZyJh4E1/Z9ws+W43eiiidc9545zFHIZAi9xYxJ1NospfjFRn9C1smn1jw0WRmLTjxD30jfyOdZVe+BdTgxaQtNN8ZbJbTM8a5Lo3cxFa+2RIGxzvW8ZFWXOREkmwiyr/Ef2VCoXgp8zGc3REyQnj+s1kWBzQudoQ3yhZtD8nCbt5oN6s4/lFVGxO91fqR8AQqvtXUpDlTI9UhV8dFXO2c1UvmnvDGr8ZU50dyeutv9fIPXuFZKXsX+LigISzM4aB2BtdFEjvMkULEqIAyY5qt9ve3Co2TUX+imuscOsXz/6SZ7NW66Q==",
      "image" : {
        "publisher" : "Canonical",
        "offer" : "0001-com-ubuntu-server-focal",
        "sku" : "20_04-lts-gen2",
        "version" : "latest"
      },
      "disk" : {
        "name" : "disk-vmlinux${var.name}${random_string.this.result}"
        "storage_account_type" : "Standard_LRS",
        "caching" : "ReadWrite",
        "disk_size_gb" : 50
      },
      "nic" : {
        "default" : {
          "name" : "nic-vmlinux${var.name}${random_string.this.result}",
          "ip_configuration" : {
            "primary" : {
              "name" : "ipconf-nic-vmlinux${var.name}${random_string.this.result}-primary"
              "private_ip_address_allocation" : "Dynamic",
              "subnet_id" : azurerm_subnet.vm.id,
              "primary" : true
            }
          }
        }
      }
    }
  }
}