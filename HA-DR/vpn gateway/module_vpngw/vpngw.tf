
resource "azurerm_public_ip" "vpn_publicIP" {
  name                = format("PublicIP_%s",var.vpngw_name)
  location            = data.azurerm_resource_group.vpngw_rg.location
  resource_group_name = data.azurerm_resource_group.vpngw_rg.name

  allocation_method = "Dynamic"
  #sku               = var.vpn_publicIP_sku
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vpngw_name
  location            = data.azurerm_resource_group.vpngw_rg.location
  resource_group_name = data.azurerm_resource_group.vpngw_rg.name

  type                = "Vpn"
  vpn_type            = "RouteBased"

  active_active       = var.vpngw_active_active
  enable_bgp          = var.vpngw_enable_bgp
  sku                 = var.vpngw_sku

  ip_configuration {
    name                          = format("vpngw-config_%s",var.vpngw_name)
    public_ip_address_id          = azurerm_public_ip.vpn_publicIP.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpngw_subnet.id
  }

  vpn_client_configuration {
    address_space = var.vpngw_client_address_prefixes

    root_certificate {
      name = var.vpngw_rootcertificate_name

      public_cert_data = azurerm_key_vault_secret.vpn-root-certificate.value
      
      /*<<EOF
      MIIC3zCCAcegAwIBAgIQNe+u7v3m1plPc0EgPg5nAjANBgkqhkiG9w0BAQsFADAS
MRAwDgYDVQQDDAdCVk1UZWNoMB4XDTIwMDgwMTA3NDg0NloXDTIxMDgwMTA4MDg0
NlowEjEQMA4GA1UEAwwHQlZNVGVjaDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMLYmqz/0itvHM4X1nkA+UWOCT2lidhLMDuCnGKU+ZK2nTZJgzIFibY9
Og+hMsA99S2/ju5j81xruIRF8w7Gzyy9GQllEgbtkvF3i7GPe47zkw04r7LoXJsL
MoJATO6zJYUVMUhmG98rZLi5zl0D3sFFlw+jtq2SmVHtiZCbj5E+9WFVZ3UleNLd
z0zmJZyd9Yuihc1BJCM/QSlwOu9VkW0+uxjSbItQdHeHMvidYTwpf0ZPXgzF1Ekw
8JR81F8OJZ9ucLWQUKoxifLALcOzPIaF33D1o0IBRXV0Vs92NZLuzAydEXu/9aHF
LRhSzUHz43CJCTefl+72BcAmgM/wGYkCAwEAAaMxMC8wDgYDVR0PAQH/BAQDAgIE
MB0GA1UdDgQWBBSxyV4ncSYVe45cZrbmJrJB3s+2NjANBgkqhkiG9w0BAQsFAAOC
AQEAl0FSPE3Zf5Bns93M339p5cQDjitvEONKyjPpaIBIZ0BPZ4WnmoHL6+VV70Aa
wYw3JAdyRWPcpZbyeIKB68D0fXOHx661lKWjYbM0dLoK/z7RB6m0J6zgLY8j/+q4
WREDV2sdow/r57soiQWgipfdxLPgWP8950Tg7mE5KquzCc2PoqXYMhi+TLFUxRHG
pINY2CGBf2w9I6gMaADV+oIEhKVFzVPIA66gwWU95hh75j7u5vyewbv7opGsuoDn
qz/ve6LvYMu96Mgptt5sR3phtNsIpiqak72wPMcw1cjptA6DqtGvqwbcHZrt8rz3
l6EgycpkWZcWJh+TICH8VX0aFw==
EOF*/
    }
  }
}