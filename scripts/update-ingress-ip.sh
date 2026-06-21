#!/usr/bin/env bash
set -euo pipefail

# Fetch the ingress-nginx external IP and update Azure DNS A records
# Usage: ./update-ingress-ip.sh <dns-zone> <resource-group> [--context <kube-context>]

DNS_ZONE="${1:-}"
DNS_RG="${2:-}"
KUBE_CONTEXT=""

if [[ -z "$DNS_ZONE" || -z "$DNS_RG" ]]; then
  echo "Usage: $0 <dns-zone> <resource-group> [--context <kube-context>]" >&2
  exit 1
fi

shift 2
while [[ $# -gt 0 ]]; do
  case "$1" in
    --context) KUBE_CONTEXT="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

KUBECTL="kubectl"
if [[ -n "$KUBE_CONTEXT" ]]; then
  KUBECTL="kubectl --context $KUBE_CONTEXT"
fi

echo "Waiting for ingress-nginx external IP..."
for _ in $(seq 1 30); do
  IP=$($KUBECTL get svc ingress-nginx-controller -n ingress-nginx \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
  if [[ -n "$IP" ]]; then
    break
  fi
  sleep 10
done

if [[ -z "$IP" ]]; then
  echo "Timed out waiting for ingress external IP" >&2
  exit 1
fi

echo "Ingress IP: $IP"
echo "Updating DNS zone: $DNS_ZONE in $DNS_RG"

az network dns record-set a add-record \
  --resource-group "$DNS_RG" \
  --zone-name "$DNS_ZONE" \
  --record-set-name "@" \
  --ipv4-address "$IP" \
  --ttl 300

az network dns record-set a add-record \
  --resource-group "$DNS_RG" \
  --zone-name "$DNS_ZONE" \
  --record-set-name "api" \
  --ipv4-address "$IP" \
  --ttl 300

echo "DNS records updated: @ and api -> $IP"
