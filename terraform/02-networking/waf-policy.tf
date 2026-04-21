resource "azurerm_web_application_firewall_policy" "main" {
  count               = var.enable_application_gateway && var.enable_waf ? 1 : 0
  name                = "wafpol-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  tags                = local.common_tags

  policy_settings {
    enabled                     = true
    mode                        = var.waf_mode
    request_body_check          = true
    max_request_body_size_in_kb = 128
    file_upload_limit_in_mb     = 100
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }

    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.0"
    }
  }

  custom_rules {
    name      = "RateLimitPerIP"
    priority  = 1
    rule_type = "RateLimitRule"
    action    = "Block"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }
      operator           = "IPMatch"
      negation_condition = true
      match_values       = ["10.0.0.0/8", "172.16.0.0/12"]
    }

    rate_limit_duration  = "OneMin"
    rate_limit_threshold = 300
  }
}
