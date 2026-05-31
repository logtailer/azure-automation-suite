resource "azurerm_application_insights_workbook" "platform_overview" {
  name                = "550f9e53-1234-4567-abcd-platform-overview"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  display_name        = "Platform Overview"

  data_json = jsonencode({
    version       = "Notebook/1.0"
    items         = []
    styleSettings = {}
    "$schema"     = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = var.tags
}
