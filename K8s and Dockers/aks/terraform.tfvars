environment             = "Development"
resource_group_name     = "rg_test_tf"
location                = "East US"
vnet_name               = "vnet_tf"
vnet_rg                 = "rg_vnet_tf"
aks_subnet_name         = "AksSubnet01"
aks_subnet_address_cidr = ["10.0.3.0/24"]
aks_name                = "aks-cluster"
aks_dns_prefix          = "BVMT"
kubernetes_version      = "1.19.0"
aks_default_node_pool_name = "default"
aks_default_node_pool_count = 2
aks_default_node_pool_vm_size = "Standard_DS2_V2"
aks_default_node_pool_type = "VirtualMachineScaleSets"
aks_network_plugin = "azure"
aks_dns_service_ip = "10.0.5.5"
aks_docker_bridge_cidr = "192.168.0.1/16"
aks_load_balancer_sku = "Standard"
aks_service_cidr = "10.0.5.0/24"
aks_nsg_rule_file = "nsg.csv"
enable_log_analytics_workspace = true
log_analytics_workspace_sku = "PerGB2018"
log_retention_in_days = 30
aks_service_principal_client_id = "f500b1cd-5ff6-47fd-9d89-8075daaf6ca5"
key_vault_name = "KeyVault01-tf"
key_vault_rg_name = "RG_TF"
key_vault_aks_service_secret_name = "aks-sevice-principal-secret"
aks_node_pool = [
    {
        name = "np01"
        size = "Standard_DS2_V2"
        node_count = 2
        enable_auto_scaling = true
        max_count = 5
        min_count = 2
        os_type = "Windows"
    }
]