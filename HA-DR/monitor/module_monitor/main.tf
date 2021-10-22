provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = var.action_group_name
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = var.action_group_short_name

  email_receiver {
    name                    = var.user_name
    email_address           = var.user_mail_address
    use_common_alert_schema = true
  }

}

resource "azurerm_application_insights" "application_insight" {
  name                = var.application_insight_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "other"
}

