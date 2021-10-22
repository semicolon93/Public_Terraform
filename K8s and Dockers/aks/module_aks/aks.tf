
resource "azurerm_kubernetes_cluster" "aks_service" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.aks_rg.location
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.kubernetes_version
  #node_resource_group = "${var.aks_name}_node_rg"

  default_node_pool {
    name       = var.aks_default_node_pool_name
    node_count = var.aks_default_node_pool_count
    vm_size    = var.aks_default_node_pool_vm_size
    type       = var.aks_default_node_pool_type
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    enable_auto_scaling   = true #var.aks_node_pool[count.index].enable_auto_scaling
    max_count             = 10 #var.aks_node_pool[count.index].enable_auto_scaling == true ? var.aks_node_pool[count.index].max_count : null
    min_count             = 1 #var.aks_node_pool[count.index].enable_auto_scaling == true ? var.aks_node_pool[count.index].min_count : null

  }
  
  service_principal {
    client_id = var.aks_service_principal_client_id
    client_secret = data.azurerm_key_vault_secret.aks_service_principal_client_secret.value
  }
  /*
  identity {
    type = "SystemAssigned"
  }*/
  
  network_profile {
    network_plugin = var.aks_network_plugin
    dns_service_ip = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    load_balancer_sku = var.aks_load_balancer_sku
    service_cidr = var.aks_service_cidr
  }
  
  

  addon_profile {
    
    oms_agent {
        enabled = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
    }
  }
  tags = {
    Environment = var.environment
  }
}
/*
# Creating nodepool 
resource "azurerm_kubernetes_cluster_node_pool" "aks_nodepool" {
  count = length(var.aks_node_pool)
  name                  = var.aks_node_pool[count.index].name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_service.id
  vm_size               = var.aks_node_pool[count.index].size
  node_count            = var.aks_node_pool[count.index].node_count
  enable_auto_scaling   = var.aks_node_pool[count.index].enable_auto_scaling
  max_count             = var.aks_node_pool[count.index].enable_auto_scaling == true ? var.aks_node_pool[count.index].max_count : null
  min_count             = var.aks_node_pool[count.index].enable_auto_scaling == true ? var.aks_node_pool[count.index].min_count : null
  #os_type               = var.aks_node_pool[count.index].os_type
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id


  tags = {
    Environment = "Production"
  }
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
*/

data "azurerm_resources" "aks_mc_default_node_pool" {
  resource_group_name = azurerm_kubernetes_cluster.aks_service.node_resource_group
  type = "Microsoft.Compute/virtualMachineScaleSets"
  depends_on = [azurerm_kubernetes_cluster.aks_service, null_resource.delay]
}

data "azurerm_virtual_machine_scale_set" "aks_default_node_pool" {
  name = data.azurerm_resources.aks_mc_default_node_pool.resources[0].name
  resource_group_name = azurerm_kubernetes_cluster.aks_service.node_resource_group
  depends_on = [azurerm_kubernetes_cluster.aks_service, null_resource.delay]
}

resource "azurerm_monitor_autoscale_setting" "aks_autoscale" {
  name                = "myAutoscaleSetting"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  location            = data.azurerm_resource_group.aks_rg.location
  target_resource_id  = data.azurerm_virtual_machine_scale_set.aks_default_node_pool.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = data.azurerm_virtual_machine_scale_set.aks_default_node_pool.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 9
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = data.azurerm_virtual_machine_scale_set.aks_default_node_pool.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 6
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["dev.azure@bvmtechnology.com"]
    }
  }
}
