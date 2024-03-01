#!/usr/bin/bash
set -e

# -----------------------------------------------------------------------------
# Call a remote SIP device through a SIP server.
#
# Packages:
#   apt-get install curl jq
#
# Usage:
#   export SELECTOR_HOST="http://172.17.17.1:8015"
#   export JITSI_HOST="https://jitsi.mydomain.corp"
#   export JITSI_ROOM="myroom"
#   export CALLER_USERNAME="1009@sip.mydomain.corp"
#   export CALLER_PASSWORD="1234"
#   export SIP_PROXY="sip:sip.mydomain.corp;transport=udp;hide"
#   export PRIVATE_KEY_FILE="/some-path/asap-signal.key"
#
#   bash sip-jibri-outgoing-start.sh <CALLEE>
#
# Example:
#   bash sip-jibri-outgoing-start.sh "sip:1001@sip.mydomain.corp"
# ------------------------------------------------------------------------------
[[ -z "$PRIVATE_KEY_FILE" ]] && \
  PRIVATE_KEY_FILE="../../files/asap/asap.key" || \
  true

CALLEE="$1"

[[ -z "$DISPLAY_NAME" ]] && \
  DISPLAY_NAME=$(echo $CALLEE | cut -d: -f2 | cut -d@ -f1) || \
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
    "type": "SIP-JIBRI",
    "region": "default-region",
    "environment": "default-env"
  },
  "metadata": {
    "sipClientParams": {
      "userName": "$CALLER_USERNAME",
      "password": "$CALLER_PASSWORD",
      "sipAddress": "$CALLEE",
      "displayName": "$DISPLAY_NAME",
      "proxy": "$SIP_PROXY",
      "autoAnswer": false
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
  -X POST $SELECTOR_HOST/jitsi-component-selector/sessions/start \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/json" \
  --data @- <<< $JSON | jq '.'
