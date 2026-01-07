# 05-Observability Module

## Overview
Comprehensive observability solution providing centralized logging, metrics visualization, and proactive alerting for the Azure platform.

## Features

### Core Monitoring
- Log Analytics Workspace (30-day retention)
- Application Insights  
- Azure Managed Grafana
- Azure Monitor Prometheus

### Infrastructure Monitoring
- AKS cluster health
- Storage availability
- Application performance

### IDP (Backstage) Monitoring  
- Container Instance metrics (CPU, memory, restarts)
- PostgreSQL performance (CPU, memory, storage, connections)
- Container Registry activity
- Diagnostic logs integration

## Quick Start

### Deployment
```bash
cd terraform/05-observability
./deploy.sh production.tfvars
```

### Access Grafana
```bash
terraform output grafana_url
```

## Configuration

### Required Variables
- `resource_group_name`: Resource group name
- `admin_email`: Email for alert notifications

### Optional Features
```hcl
enable_idp_monitoring     = true  # Monitor Backstage/IDP
enable_prometheus_metrics = true  # Enable Prometheus workspace
```

## Documentation
- [Monitoring Guide](MONITORING_GUIDE.md) - Comprehensive setup and usage
- [Foundation Module](../01-foundation/) - Base infrastructure  
- [IDP Module](../07-idp/) - Backstage platform

## Outputs
- `grafana_url`: Grafana dashboard URL
- `log_analytics_workspace_id`: Log Analytics workspace ID
- `application_insights_instrumentation_key`: App Insights key (sensitive)
