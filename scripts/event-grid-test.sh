#!/usr/bin/env bash
set -euo pipefail

# Publish a test CloudEvent to an Event Grid topic and verify delivery
# Usage: ./event-grid-test.sh <topic-endpoint> <topic-key>

TOPIC_ENDPOINT="${1:-}"
TOPIC_KEY="${2:-}"

if [[ -z "$TOPIC_ENDPOINT" || -z "$TOPIC_KEY" ]]; then
  echo "Usage: $0 <topic-endpoint> <topic-key>" >&2
  exit 1
fi

EVENT_ID="test-$(date +%s)"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

PAYLOAD=$(cat <<EOF
[{
  "specversion": "1.0",
  "type": "platform.test.ping",
  "source": "/scripts/event-grid-test",
  "id": "$EVENT_ID",
  "time": "$TIMESTAMP",
  "datacontenttype": "application/json",
  "data": {
    "message": "connectivity test",
    "timestamp": "$TIMESTAMP"
  }
}]
EOF
)

echo "Publishing CloudEvent to: $TOPIC_ENDPOINT"
echo "Event ID: $EVENT_ID"

_RESPONSE=$(curl -sf -X POST "$TOPIC_ENDPOINT/events" \
  -H "aeg-sas-key: $TOPIC_KEY" \
  -H "Content-Type: application/cloudevents-batch+json" \
  -d "$PAYLOAD" \
  -w "\nHTTP_STATUS:%{http_code}" \
  -o /tmp/egtest_response.txt 2>&1 || true)

HTTP_STATUS=$(grep "HTTP_STATUS:" /tmp/egtest_response.txt | cut -d: -f2)

if [[ "$HTTP_STATUS" == "200" ]]; then
  echo "Event published successfully (HTTP $HTTP_STATUS)"
else
  echo "Failed to publish event (HTTP $HTTP_STATUS)" >&2
  cat /tmp/egtest_response.txt >&2
  exit 1
fi
