locals {
  publicIP_name = format("PublicIP_%s",var.appgw_name)
  privateIP_name = format("PrivateIP_%s",var.appgw_name)
  frontend_port_name = format("FrontendPort_%s",var.appgw_name)
  frontend_publicIP_configuration_name =  format("Frontend_PubIPConfig_%s",var.appgw_name)
  frontend_privateIP_configuration_name =  format("Frontend_PvtIPConfig_%s",var.appgw_name)

}

resource "azurerm_public_ip" "appgw_publicIP" {
  name                = local.publicIP_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = var.environment
  }
}

resource "azurerm_application_gateway" "network" {
  name                = var.appgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    #capacity = var.appgw_capacity
  }

  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.1"
  }

  #firewall_policy_id = azurerm_web_application_firewall_policy.appgw_waf_policy.id

  gateway_ip_configuration {
    name      = local.privateIP_name
    subnet_id = azurerm_subnet.appgw_frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.appgw_frontend_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_publicIP_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_publicIP.id
  }

  frontend_ip_configuration {
    name                 = local.frontend_privateIP_configuration_name
    private_ip_address = var.appgw_frontend_private_ip_address
    private_ip_address_allocation = "Static"
    subnet_id = azurerm_subnet.appgw_frontend.id
  }

  backend_address_pool {
    name = var.appgw_backend_address_pool_name
    ip_addresses = var.appgw_backend_ip_addresses
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }
  /*
  ssl_certificate {
    name = var.appgw_kv_sslcertificate_name
    key_vault_secret_id = data.azurerm_key_vault_certificate.appgw_sslcertificate.secret_id
  }

  trusted_root_certificate {
    name = var.appgw_kv_trustedrootcertificate_name
    data = data.azurerm_key_vault_certificate.appgw_kv_trustedrootcertificate.value
  }
*/

  dynamic "probe" {
    for_each = [for probe in var.hostnames : {
      frontendhostname = probe.frontendhostname
      backendhostname = probe.backendhostname
      probePath = probe.probePath
      backendPort = probe.backendPort
      timeout = probe.timeout
    }]

    content {
      name = format("%s_probe", probe.value.frontendhostname)
      protocol = "Http"
      pick_host_name_from_backend_http_settings = true
      path = probe.value.probePath
      interval = 30
      timeout = probe.value.timeout
      unhealthy_threshold = 5
    }
  }
  
  dynamic "backend_http_settings" {

    for_each = [for backend_http_setting in var.hostnames: {
      frontendhostname    = backend_http_setting.frontendhostname
      backendhostname     = backend_http_setting.backendhostname
      probePath           = backend_http_setting.probePath
      backendPort         = backend_http_setting.backendPort
      timeout             = backend_http_setting.timeout
    }]
    content {
      name                  = backend_http_settings.value.frontendhostname
      cookie_based_affinity = "Enabled"
      port                  = backend_http_settings.value.backendPort
      protocol              = "Http"
      request_timeout       = 60
      host_name             = backend_http_settings.value.backendhostname
      #trusted_root_certificate_names =  [var.appgw_kv_trustedrootcertificate_name]
      probe_name = format("%s_probe",backend_http_settings.value.frontendhostname )
    }
  }

  dynamic "http_listener" {

    for_each = [for http_listener in var.hostnames: {
      frontendhostname = http_listener.frontendhostname
      backendhostname  = http_listener.backendhostname
      probePath        = http_listener.probePath
      backendPort      = http_listener.backendPort
      timeout          = http_listener.timeout
    }]
    content {
      name                           = format("%s_http_listener", http_listener.value.frontendhostname)
      frontend_ip_configuration_name = local.frontend_privateIP_configuration_name
      frontend_port_name             = local.frontend_port_name
      host_name                      = http_listener.value.frontendhostname
      protocol                       = "Http"
      require_sni                    = false
      #ssl_certificate_name           = var.appgw_kv_sslcertificate_name
    }
  }

  dynamic "request_routing_rule" {

    for_each = [for request_routing_rule in var.hostnames: {
      frontendhostname    = request_routing_rule.frontendhostname
      backendhostname     = request_routing_rule.backendhostname
      probePath           = request_routing_rule.probePath
      backendPort         = request_routing_rule.backendPort
      timeout             = request_routing_rule.timeout
    }]
    content {
      name                       = request_routing_rule.value.frontendhostname
      rule_type                  = "Basic"
      http_listener_name         = format("%s_http_listener", request_routing_rule.value.frontendhostname)
      backend_address_pool_name  = var.appgw_backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.frontendhostname
    }
    
  }
  identity {
    identity_ids = [azurerm_user_assigned_identity.managed_user.id]
  }

  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"
    cipher_suites        = var.appgw_tls_ciphers
  }

  tags = {
    environment = var.environment
  }

  depends_on =[]
}

resource "azurerm_log_analytics_workspace" "appgw_log_analytics" {
  name                = var.appgw_log_analytics_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = var.appgw_log_analytics_sku
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "appgw_solution" {
  solution_name         = "AzureAppGatewayAnalytics"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  workspace_resource_id = azurerm_log_analytics_workspace.appgw_log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.appgw_log_analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureAppGatewayAnalytics"
  }
}