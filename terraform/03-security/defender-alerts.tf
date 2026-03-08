resource "azurerm_security_center_contact" "main" {
  email               = var.security_contact_email
  alert_notifications = var.alert_notifications_enabled
  alerts_to_admins    = var.alerts_to_admins_enabled
}
