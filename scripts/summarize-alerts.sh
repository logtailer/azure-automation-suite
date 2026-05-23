#!/usr/bin/env bash
set -euo pipefail

# Summarise fired Azure Monitor alerts from the past N hours
# Usage: ./summarize-alerts.sh [--hours <n>] [--rg <resource-group>] [--severity <0-4>]

HOURS=24
RESOURCE_GROUP=""
SEVERITY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --hours)    HOURS="$2";         shift 2 ;;
    --rg)       RESOURCE_GROUP="$2"; shift 2 ;;
    --severity) SEVERITY="$2";      shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

START_TIME=$(date -u -d "-${HOURS} hours" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null \
            || date -u -v-${HOURS}H +%Y-%m-%dT%H:%M:%SZ)

echo "=== Azure Monitor Alert Summary ==="
echo "    Period   : last ${HOURS} hours (since ${START_TIME})"
[[ -n "$RESOURCE_GROUP" ]] && echo "    Scope    : $RESOURCE_GROUP"
[[ -n "$SEVERITY"       ]] && echo "    Severity : $SEVERITY"
echo ""

FILTER="alertState eq 'Fired' and startDateTime ge ${START_TIME}"
[[ -n "$SEVERITY" ]] && FILTER="${FILTER} and severity eq 'Sev${SEVERITY}'"

RG_ARG=""
[[ -n "$RESOURCE_GROUP" ]] && RG_ARG="--resource-group $RESOURCE_GROUP"

ALERTS=$(az monitor alert-instances list \
  $RG_ARG \
  --query "[?properties.alertRule.properties.severity!=''].{Name:properties.alertRule.name,Sev:properties.severity,State:properties.alertState,Fired:properties.startDateTime,Resource:properties.targetResourceName}" \
  -o json 2>/dev/null || echo "[]")

COUNT=$(echo "$ALERTS" | jq 'length')
echo "Total alerts fired: $COUNT"
echo ""

if [[ "$COUNT" -eq 0 ]]; then
  echo "No alerts fired in the specified window."
  exit 0
fi

echo "--- By Severity ---"
echo "$ALERTS" | jq -r 'group_by(.Sev)[] | "\(.[0].Sev): \(length)"' | sort

echo ""
echo "--- Top 20 Most Recent ---"
echo "$ALERTS" | jq -r '
  (["SEVERITY","STATE","FIRED","RESOURCE","ALERT"] | @tsv),
  (sort_by(.Fired) | reverse | .[0:20][] |
    [.Sev, .State, (.Fired // "unknown")[0:19], (.Resource // "unknown"), .Name] | @tsv)
' | column -t
