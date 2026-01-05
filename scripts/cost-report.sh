#!/bin/bash
# Cost Analysis Report Generator
# This script generates component-wise cost reports

set -e

ENVIRONMENT="${1:-dev}"
PROJECT_NAME="${2:-azure-platform}"
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

echo "🔍 Generating Cost Analysis Report for $ENVIRONMENT environment..."
echo "=================================================="

# Get current month costs by resource group
echo "📊 Component-wise Costs (Current Month):"
echo "----------------------------------------"

# Query costs for each component
COMPONENTS=("foundation" "networking" "security" "aks" "observability" "cicd" "idp")

TOTAL_COST=0

for component in "${COMPONENTS[@]}"; do
  RG_NAME="${PROJECT_NAME}-${component}-${ENVIRONMENT}-rg"
  
  # Get cost data for the resource group (current month)
  COST=$(az consumption usage list \
    --billing-period-name $(date +%Y%m) \
    --query "[?contains(instanceName, '$RG_NAME')].pretaxCost" \
    --output tsv 2>/dev/null | awk '{s+=$1} END {print s}' || echo "0")
  
  if [[ -z "$COST" ]] || [[ "$COST" == "" ]]; then
    COST="0"
  fi
  
  # Format cost to 2 decimal places
  FORMATTED_COST=$(printf "%.2f" "$COST" 2>/dev/null || echo "0.00")
  TOTAL_COST=$(echo "$TOTAL_COST + $FORMATTED_COST" | bc -l 2>/dev/null || echo "$TOTAL_COST")
  
  # Get budget for this component
  BUDGET=$(echo 'var.component_budgets["'$component'"].amount' | jq -r '.amount // 5' 2>/dev/null || echo "5")
  
  # Calculate percentage of budget used
  if (( $(echo "$BUDGET > 0" | bc -l 2>/dev/null || echo 0) )); then
    PERCENT=$(echo "scale=1; $FORMATTED_COST * 100 / $BUDGET" | bc -l 2>/dev/null || echo "0")
  else
    PERCENT="0"
  fi
  
  # Color coding based on usage
  if (( $(echo "$PERCENT > 80" | bc -l 2>/dev/null || echo 0) )); then
    COLOR="🔴"
  elif (( $(echo "$PERCENT > 50" | bc -l 2>/dev/null || echo 0) )); then
    COLOR="🟡"
  else
    COLOR="🟢"
  fi
  
  printf "%-15s %s \$%-8s / \$%-5s (%s%%)\n" \
    "$component" "$COLOR" "$FORMATTED_COST" "$BUDGET" "$PERCENT"
done

echo "----------------------------------------"
TOTAL_FORMATTED=$(printf "%.2f" "$TOTAL_COST" 2>/dev/null || echo "0.00")
echo "Total Cost: \$$TOTAL_FORMATTED"

# Get overall budget
OVERALL_BUDGET="50"  # Default from tfvars
OVERALL_PERCENT=$(echo "scale=1; $TOTAL_COST * 100 / $OVERALL_BUDGET" | bc -l 2>/dev/null || echo "0")

echo "Overall Budget: \$$OVERALL_BUDGET ($OVERALL_PERCENT% used)"

echo ""
echo "📈 Top Expensive Components:"
echo "----------------------------"
# This would require more complex Azure CLI queries to get actual resource costs

echo ""
echo "💡 Cost Optimization Recommendations:"
echo "------------------------------------"

if (( $(echo "$OVERALL_PERCENT > 80" | bc -l 2>/dev/null || echo 0) )); then
  echo "⚠️  You're using >80% of your budget! Consider:"
  echo "   • Scaling down non-production resources"
  echo "   • Using Azure Reserved Instances for VMs"
  echo "   • Implementing auto-shutdown for dev resources"
elif (( $(echo "$OVERALL_PERCENT > 50" | bc -l 2>/dev/null || echo 0) )); then
  echo "⚡ You're halfway through your budget. Monitor closely."
else
  echo "✅ Your costs are under control. Good job!"
fi

echo ""
echo "🔗 Useful Commands:"
echo "------------------"
echo "View detailed costs: az consumption usage list --start-date $(date -d 'last month' +%Y-%m-01) --end-date $(date +%Y-%m-01)"
echo "Check budgets: az consumption budget list"
echo "Cost analysis: https://portal.azure.com/#view/Microsoft_Azure_CostManagement"
