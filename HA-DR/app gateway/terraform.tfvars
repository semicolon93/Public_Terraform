environment             = "Development"
resource_group_name     = "rg_test_tf"
location                = "East US"
vnet_name               = "vnet_tf"
vnet_rg                 = "rg_vnet_tf"
managed_identity_name   = "ManagedIdentitytf"
#keyvault_id = 
#appgw_kv_sslcertificate_name = 
#appgw_kv_trustedrootcertificate_name = 
appgw_name              = "app_gateway_tf"
appgw_sku_name          = "WAF_v2" 
appgw_sku_tier          = "WAF_V2"
#appgw_capacity         = 2
appgw_frontend_port     = "80"
appgw_frontend_private_ip_address   = "10.0.6.25"
appgw_backend_address_pool_name     = "backend_pool_tf"
appgw_backend_ip_addresses          = ["10.0.2.4"]
hostnames = [
    {
    frontendhostname = "abc.frontend.com"
    backendhostname = "abc.backend.com"
    probePath = "/"
    backendPort = "8542"
    timeout = "30"
    },
    {
    frontendhostname = "def.frontend.com"
    backendhostname = "def.backend.com"
    probePath = "/"
    backendPort = "8642"
    timeout = "30"
    }
  ]
appgw_log_analytics_name        = "AppGatewayLogtf"
appgw_log_analytics_sku         = "PerGB2018"
appgw_frontend_subnet_name      = "appgw_frontend"
appgw_frontend_subnet_address_prefixes = ["10.0.6.0/24"]
log_analytics_workspace_id = "/subscriptions/f89af65a-c2f3-484e-a97d-3dc9bf809c5b/resourcegroups/rg_test_tf/providers/microsoft.operationalinsights/workspaces/loganalytics-tf"

