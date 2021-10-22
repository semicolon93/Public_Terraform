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
    client_secret = var.client_secret
  }
# Add rbac policy
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
