data "azurerm_subscription" "current" {
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.aks_dns_prefix

  kubernetes_version = var.aks_version

  default_node_pool {
    name            = var.aks_agent_pool
    node_count      = var.aks_agent_count
    vm_size         = var.aks_agent_size
    type            = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.main-aks.id
    enable_auto_scaling   = true 
    max_count             = 10 
    min_count             = 2 
  }

  service_principal {
    client_id     = var.client_id
    client_secret = data.azurerm_key_vault_secret.client_secret.value
  }
# Add rbac policy
  role_based_access_control {
    enabled = true
  /*  azure_active_directory {
      managed = false
      
      tenant_id = data.azurerm_subscription.current.tenant_id
      admin_group_object_ids = ["a56035f0-580e-4212-9ada-e4c4e98aa260"]
      
      client_app_id = 
      server_app_id = 
      server_app_secret = 
    }*/
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
    service_cidr = "10.66.1.0/24"
    dns_service_ip = "10.66.1.5"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  addon_profile {
    oms_agent {
        enabled = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
    }
    kube_dashboard {
      enabled = true
    }
    http_application_routing {
      enabled = true
    }
  }
}

# helm charts for application -- > start with Wordpress 

#Private DNS zone
