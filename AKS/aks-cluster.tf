provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${resource_group}-aks"
  location            = "West US 2"
  resource_group_name = var.resource_group
  dns_prefix          = "${resource_group}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "dev"
  }
}
