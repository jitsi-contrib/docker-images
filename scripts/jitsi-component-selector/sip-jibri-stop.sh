#!/usr/bin/bash
set -e

# -----------------------------------------------------------------------------
# Packages:
#   apt-get install curl
#
# Usage:
#   export SELECTOR_HOST="http://172.17.17.1:8015"
#   export JITSI_HOST="https://jitsi.mydomain.corp"
#   export JITSI_ROOM="myroom"
#   export PRIVATE_KEY_FILE="/some-path/asap-signal.key"
#
#   bash sip-jibri-stop.sh <SESSION_ID>
#
# Example:
#   bash sip-jibri-stop.sh "e7c18272-284b-433f-b80d-b12d9fa17035"
# ------------------------------------------------------------------------------
[[ -z "$PRIVATE_KEY_FILE" ]] && \
  PRIVATE_KEY_FILE="../../files/asap/asap.key" || \
  true

SESSION_ID="$1"

JSON=$(cat <<EOF
{
  "sessionId": "$SESSION_ID",
  "callParams": {
    "callUrlInfo": {
      "baseUrl": "$JITSI_HOST",
      "callName": "$JITSI_ROOM"
    }
  }
}
EOF
)

# generate the bearer token
HEADER=$(echo -n '{"alg":"RS256","typ":"JWT","kid":"jitsi/signal"}' | \
  base64 | tr '+/' '-_' | tr -d '=\n')
PAYLOAD=$(echo -n '{"iss":"signal","aud":"jitsi-component-selector"}' | \
  base64 | tr '+/' '-_' | tr -d '=\n')
SIGN=$(echo -n "$HEADER.$PAYLOAD" | \
  openssl dgst -sha256 -binary -sign $PRIVATE_KEY_FILE | \
  openssl enc -base64 | tr '+/' '-_' | tr -d '=\n')
TOKEN="$HEADER.$PAYLOAD.$SIGN"

curl -sk \
  -X POST $SELECTOR_HOST/jitsi-component-selector/sessions/stop \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/json" \
  --data @- <<< $JSON
