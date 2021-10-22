resource "azurerm_monitor_diagnostic_setting" "appgw_pip" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "appgw-pip-log-analytics"
  target_resource_id         = azurerm_public_ip.appgw_publicIP.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "DDoSProtectionNotifications"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DDoSMitigationFlowLogs"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DDoSMitigationReports"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}


resource "azurerm_monitor_diagnostic_setting" "appgw" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "appgw-analytics"
  target_resource_id         = azurerm_application_gateway.network.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "ApplicationGatewayAccessLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

}
