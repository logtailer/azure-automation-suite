#!/usr/bin/env bash
set -euo pipefail

# Run Azure Network Watcher connectivity checks between source and destination
# Usage: ./az-network-diagnostics.sh --source-vm <vm-id> --dest-ip <ip> [--dest-port <port>] [--rg <rg>]

SOURCE_VM_ID=""
DEST_IP=""
DEST_PORT="443"
RESOURCE_GROUP=""
LOCATION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-vm)   SOURCE_VM_ID="$2"; shift 2 ;;
    --dest-ip)     DEST_IP="$2";      shift 2 ;;
    --dest-port)   DEST_PORT="$2";    shift 2 ;;
    --rg)          RESOURCE_GROUP="$2"; shift 2 ;;
    --location)    LOCATION="$2";     shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$SOURCE_VM_ID" ]] && { echo "ERROR: --source-vm required" >&2; exit 1; }
[[ -z "$DEST_IP"      ]] && { echo "ERROR: --dest-ip required"   >&2; exit 1; }

if [[ -z "$LOCATION" ]]; then
  LOCATION=$(az vm show --ids "$SOURCE_VM_ID" --query "location" -o tsv)
fi
if [[ -z "$RESOURCE_GROUP" ]]; then
  RESOURCE_GROUP=$(az vm show --ids "$SOURCE_VM_ID" --query "resourceGroup" -o tsv)
fi

NW_NAME="NetworkWatcher_${LOCATION}"

echo "=== Azure Network Watcher Diagnostics ==="
echo "    Source VM  : $SOURCE_VM_ID"
echo "    Destination: ${DEST_IP}:${DEST_PORT}"
echo "    Location   : $LOCATION"
echo ""

echo "--- Connectivity Check ---"
az network watcher test-connectivity \
  --source-resource "$SOURCE_VM_ID" \
  --dest-address "$DEST_IP" \
  --dest-port "$DEST_PORT" \
  --resource-group "$RESOURCE_GROUP" \
  -o table

echo ""
echo "--- Effective Security Rules ---"
VM_NIC=$(az vm show --ids "$SOURCE_VM_ID" \
  --query "networkProfile.networkInterfaces[0].id" -o tsv)
az network watcher show-security-group-view \
  --resource-group "$RESOURCE_GROUP" \
  --vm "$SOURCE_VM_ID" \
  --location "$LOCATION" \
  --query "networkInterfaces[0].securityRuleAssociations.effectiveSecurityRules[?direction=='Outbound']" \
  -o table 2>/dev/null || echo "NSG view unavailable"

echo ""
echo "--- Next Hop ---"
az network watcher show-next-hop \
  --resource-group "$RESOURCE_GROUP" \
  --vm "$SOURCE_VM_ID" \
  --source-ip "$(az vm list-ip-addresses --ids "$SOURCE_VM_ID" \
    --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)" \
  --dest-ip "$DEST_IP" \
  -o table 2>/dev/null || echo "Next hop unavailable"
