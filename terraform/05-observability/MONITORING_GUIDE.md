# Observability Module Monitoring Guide

## Overview
Comprehensive monitoring for Azure platform using Grafana, Prometheus, Log Analytics, and Application Insights.

## Features

### Core Monitoring
- **Log Analytics Workspace**: Centralized log aggregation (30-day retention)
- **Application Insights**: Application performance monitoring
- **Azure Managed Grafana**: Enterprise dashboards and visualization
- **Azure Monitor Prometheus**: Prometheus-compatible metrics without custom exporters

### Infrastructure Monitoring
- AKS cluster health and performance (6 alerts)
- Storage account availability  
- Application availability and response times

### IDP (Backstage) Monitoring
- **Container Instance (ACI)**: CPU, memory, restart alerts
- **PostgreSQL Database**: CPU, memory, storage, connections, availability alerts
- **Container Registry**: Repository and login event tracking
- **Diagnostic Logs**: All logs shipped to Log Analytics

## Quick Start

### Accessing Grafana
```bash
terraform output grafana_url
# Login with Azure AD credentials
```

### Creating Dashboards

**Backstage Application Dashboard**
```
Namespace: Microsoft.ContainerInstance/containerGroups
Resource: <container-instance-id>
Metrics: CpuUsage, MemoryUsage
```

**PostgreSQL Performance Dashboard**
```
Namespace: Microsoft.DBforPostgreSQL/flexibleServers  
Resource: <postgresql-server-id>
Metrics: cpu_percent, memory_percent, storage_percent, active_connections
```

### Using Prometheus (PromQL)
```promql
# Container CPU usage
container_cpu_usage_seconds_total{container="backstage"}

# Database connections  
pg_stat_database_numbackends{database="backstage"}
```

## Alert Configuration

### Severity Levels
- **Severity 1 (Critical)**: Database availability, storage >80%
- **Severity 2 (Warning)**: CPU/memory usage, response times

### Alert Frequency
- Check: Every 5 minutes
- Window: 15 minutes (5 min for DB availability)

### Email Notifications
Configure via `admin_email` variable in tfvars.

## Cost Considerations
- Log Analytics: ~$2-5/GB/month
- Grafana: ~$175/month (Standard tier)
- Monitor Alerts: First 10 free, then $0.10/month per signal

## Troubleshooting

### Grafana Cannot Access Metrics
```bash
# Verify role assignments
az role assignment list --assignee <grafana-principal-id>
```

### Missing Logs
```kql
ContainerInstanceLog_CL
| where TimeGenerated > ago(1h)
| limit 100
```

## Configuration

Enable IDP monitoring in tfvars:
```hcl
enable_idp_monitoring     = true
enable_prometheus_metrics = true
```

## References
- [Azure Monitor Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/)
- [Grafana Docs](https://grafana.com/docs/)
- [Azure Prometheus](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview)
