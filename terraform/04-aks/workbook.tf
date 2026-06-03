resource "azurerm_application_insights_workbook" "aks_node_health" {
  count               = var.log_analytics_workspace_id != "" ? 1 : 0
  name                = "a1b2c3d4-aks0-node-0000-health00overview"
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "AKS Node Health Overview"

  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## AKS Node Health\nMonitors node CPU, memory, and disk pressure conditions across all node pools."
        }
        name = "header"
      },
      {
        type = 3
        name = "node-cpu"
        content = {
          version      = "KqlItem/1.0"
          query        = "Perf | where ObjectName == 'K8SNode' and CounterName == 'cpuUsageNanoCores' | summarize AvgCPU=avg(CounterValue) by Computer, bin(TimeGenerated, 5m) | render timechart"
          size         = 0
          title        = "Node CPU Usage"
          queryType    = 0
          resourceType = "microsoft.operationalinsights/workspaces"
        }
      },
      {
        type = 3
        name = "node-memory"
        content = {
          version      = "KqlItem/1.0"
          query        = "Perf | where ObjectName == 'K8SNode' and CounterName == 'memoryRssBytes' | summarize AvgMem=avg(CounterValue) by Computer, bin(TimeGenerated, 5m) | render timechart"
          size         = 0
          title        = "Node Memory RSS"
          queryType    = 0
          resourceType = "microsoft.operationalinsights/workspaces"
        }
      }
    ]
    styleSettings = {}
    "$schema"     = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = var.tags
}
