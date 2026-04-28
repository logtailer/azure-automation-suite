resource "azurerm_application_insights_web_test" "platform_api_ping" {
  count                   = var.enable_app_insights && var.enable_synthetic_monitor ? 1 : 0
  name                    = "webtest-platform-api-ping"
  resource_group_name     = data.azurerm_resource_group.main.name
  location                = data.azurerm_resource_group.main.location
  application_insights_id = azurerm_application_insights.platform[0].id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 30
  enabled                 = true
  geo_locations = [
    "us-ca-sjc-azr",
    "us-tx-sn1-azr",
    "us-il-ch1-azr",
    "emea-nl-ams-azr",
    "apac-sg-sin-azr",
  ]

  configuration = <<XML
<WebTest Name="platform-api-ping" Enabled="True" Timeout="30" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
  <Items>
    <Request Method="GET" Version="1.1" Url="${var.synthetic_monitor_url}" ThinkTime="0" Timeout="30" ParseDependentRequests="False" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0">
      <ValidationRules>
        <ValidationRule Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText" DisplayName="Response Code" RuleParameters="FindText=200;IgnoreCase=False;UseRegularExpression=False;PassIfTextFound=True" />
      </ValidationRules>
    </Request>
  </Items>
</WebTest>
XML

  tags = var.tags
}
