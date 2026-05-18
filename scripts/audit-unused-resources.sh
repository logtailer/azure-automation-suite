#!/usr/bin/env bash
set -euo pipefail

# Identify potentially unused Azure resources: stopped VMs, unattached disks, idle IPs
# Usage: ./audit-unused-resources.sh [--rg <resource-group>] [--output <table|json>]

RESOURCE_GROUP=""
OUTPUT_FMT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --rg)     RESOURCE_GROUP="$2"; shift 2 ;;
    --output) OUTPUT_FMT="$2";     shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

RG_ARG=""
[[ -n "$RESOURCE_GROUP" ]] && RG_ARG="--resource-group $RESOURCE_GROUP"

echo "=== Unused Azure Resource Audit ==="
[[ -n "$RESOURCE_GROUP" ]] && echo "    Scope: $RESOURCE_GROUP" || echo "    Scope: subscription"
echo ""

# Stopped (deallocated) VMs
echo "--- Stopped / Deallocated VMs ---"
az vm list $RG_ARG \
  --query "[?powerState=='VM deallocated' || powerState==null].{Name:name,RG:resourceGroup,Size:hardwareProfile.vmSize}" \
  -o "${OUTPUT_FMT}" 2>/dev/null || \
az vm list $RG_ARG -d \
  --query "[?powerState=='VM deallocated'].{Name:name,RG:resourceGroup}" \
  -o "${OUTPUT_FMT}"

echo ""
echo "--- Unattached Managed Disks ---"
az disk list $RG_ARG \
  --query "[?diskState=='Unattached'].{Name:name,RG:resourceGroup,SizeGB:diskSizeGb,SKU:sku.name}" \
  -o "${OUTPUT_FMT}"

echo ""
echo "--- Idle Public IPs (not associated) ---"
az network public-ip list $RG_ARG \
  --query "[?ipConfiguration==null].{Name:name,RG:resourceGroup,SKU:sku.name,IP:ipAddress}" \
  -o "${OUTPUT_FMT}"

echo ""
echo "--- Empty Network Security Groups ---"
az network nsg list $RG_ARG \
  --query "[?networkInterfaces==[] && subnets==[]].{Name:name,RG:resourceGroup}" \
  -o "${OUTPUT_FMT}"

echo ""
echo "--- Load Balancers with no backends ---"
az network lb list $RG_ARG \
  --query "[?backendAddressPools[0].backendIPConfigurations==null].{Name:name,RG:resourceGroup}" \
  -o "${OUTPUT_FMT}"

echo ""
echo "Audit complete. Review above resources and consider cleanup."
