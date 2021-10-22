environment             = "Development"
resource_group_name     = "rg_vnet_tf"
location                = "East US"
vnet_name               = "vnet_tf"
vnet_address_prefixes   = ["10.0.0.0/8"]
subnet = [
    {
        subnet_name = "Default"
        subnet_address_prefixes = ["10.0.0.0/24"]
    }

]


