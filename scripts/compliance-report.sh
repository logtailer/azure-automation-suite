#!/bin/bash
set -euo pipefail
SUBSCRIPTION=${1:-$(az account show --query id -o tsv)}
echo "Generating compliance report for subscription: $SUBSCRIPTION"
az policy state summarize \
  --subscription "$SUBSCRIPTION" \
  --query "results.policyAssignments[].{policy:policyAssignmentId, compliant:results.nonCompliantResources}" \
  --output table
