ws_rg_name = "rg_dev_tf"
vnet_rg = "rg_vnet_tf"
vnet_name = "Dev-QA-vnet"

web_server = [
  {
    subnet_name = "bvmtwebsn01"
    public_ip = true
    name = "web01"
    private_ip_address = "10.0.3.5"
    size = "Standard_F2" 
    admin_username = "bvmtadmin"
    admin_password = "bvmpass01#@"
    image_publisher = "MicrosoftWindowsServer"
    image_offer = "WindowsServer"
    image_sku = "2016-Datacenter"
    image_version = "latest"
    data_disk_size = 500
    },
  ]
db_server = [
  {
    subnet_name = "DevDBVM"
    public_ip = false
    name = "devdbvm01"
    private_ip_address = "192.168.2.5"
    size = "Standard_B2ms" 
    admin_username = "bvmtadmin"
    admin_password = "bvmpass01#@"
    image_publisher = "MicrosoftSQLServer"
    image_offer = "sql2019-ws2019"
    image_sku = "sqldev"
    image_version = "latest"
    data_disk_size = ["200"] # 3 data disk will be provisioned per db server. No of disk cannot be changed
    },
    {
    subnet_name = "DevDBVM"
    public_ip = false
    name = "devdbvm02"
    private_ip_address = "192.168.2.6"
    size = "Standard_B2ms" 
    admin_username = "bvmtadmin"
    admin_password = "bvmpass01#@"
    image_publisher = "MicrosoftSQLServer"
    image_offer = "sql2019-ws2019"
    image_sku = "sqldev"
    image_version = "latest"
    data_disk_size = ["200"] # 3 data disk will be provisioned per db server. No of disk cannot be changed
    },
    {
    subnet_name = "QASubnet"
    public_ip = false
    name = "qadbvm01"
    private_ip_address = "192.168.3.5"
    size = "Standard_B2ms" 
    admin_username = "bvmtadmin"
    admin_password = "bvmpass01#@"
    image_publisher = "MicrosoftSQLServer"
    image_offer = "sql2019-ws2019"
    image_sku = "sqldev"
    image_version = "latest"
    data_disk_size = ["200"] # 3 data disk will be provisioned per db server. No of disk cannot be changed
    },
    
]
