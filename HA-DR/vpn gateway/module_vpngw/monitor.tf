/*resource "azurerm_monitor_diagnostic_setting" "gw_pip" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "gw-pip-log-analytics"
  target_resource_id         = azurerm_public_ip.vpn_publicIP.id
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


resource "azurerm_monitor_diagnostic_setting" "vpngw" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "gw-analytics"
  target_resource_id         = azurerm_virtual_network_gateway.vpngw.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "GatewayDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "TunnelDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "RouteDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "IKEDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "P2SDiagnosticLog"

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
*/