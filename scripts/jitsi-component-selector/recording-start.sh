#!/usr/bin/bash
set -e

# -----------------------------------------------------------------------------
# Packages:
#   apt-get install curl jq
#
# Usage:
#   export SELECTOR_HOST="http://172.17.17.1:8015"
#   export JITSI_HOST="https://jitsi.mydomain.corp"
#   export JITSI_ROOM="myroom"
#   export PROSODY_RECORDER_PASSWD="recorder-password"
#   export PRIVATE_KEY_FILE="/some-path/asap-signal.key"
#
#   bash recording-start.sh
# ------------------------------------------------------------------------------
[[ -z "$PRIVATE_KEY_FILE" ]] && \
  PRIVATE_KEY_FILE="../../files/asap/asap.key" || \
  true

JSON=$(cat <<EOF
{
  "callParams": {
    "callUrlInfo": {
      "baseUrl": "$JITSI_HOST",
      "callName": "$JITSI_ROOM"
    }
  },
  "componentParams": {
    "type": "JIBRI",
    "region": "default-region",
    "environment": "default-env"
  },
  "metadata": {
    "sinkType": "FILE"
  },
  "callLoginParams": {
    "domain": "recorder.jitsi.mydomain.corp",
    "username": "recorder",
    "password": "$PROSODY_RECORDER_PASSWD"
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
  -X POST $SELECTOR_HOST/jitsi-component-selector/sessions/start \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/json" \
  --data @- <<< $JSON | jq '.'
