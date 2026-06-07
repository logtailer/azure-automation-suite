resource "azurerm_application_insights_workbook" "api_health" {
  count               = var.enable_workbooks ? 1 : 0
  name                = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "API Health Overview"
  source_id           = lower(var.log_analytics_workspace_id)

  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## API Health Dashboard\nReal-time view of request rates, latency, and error rates."
        }
      },
      {
        type = 3
        content = {
          version      = "KqlItem/1.0"
          query        = "requests | summarize RequestCount=count(), FailureCount=countif(success==false) by bin(timestamp, 5m) | render timechart"
          size         = 0
          title        = "Request Rate vs Failures (5m bins)"
          timeContext  = { durationMs = 3600000 }
          queryType    = 0
          resourceType = "microsoft.operationalinsights/workspaces"
        }
      },
      {
        type = 3
        content = {
          version      = "KqlItem/1.0"
          query        = "requests | summarize p50=percentile(duration,50), p95=percentile(duration,95), p99=percentile(duration,99) by bin(timestamp, 5m) | render timechart"
          size         = 0
          title        = "Latency Percentiles"
          timeContext  = { durationMs = 3600000 }
          queryType    = 0
          resourceType = "microsoft.operationalinsights/workspaces"
        }
      }
    ]
    isLocked = false
  })

  tags = var.tags
}

resource "azurerm_application_insights_workbook" "cost_overview" {
  count               = var.enable_workbooks ? 1 : 0
  name                = "b2c3d4e5-f6a7-8901-bcde-f12345678901"
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "Platform Cost Overview"
  source_id           = lower(var.log_analytics_workspace_id)

  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## Platform Cost Overview\nMonthly spend trends by component and resource type."
        }
      }
    ]
    isLocked = false
  })

  tags = var.tags
}
