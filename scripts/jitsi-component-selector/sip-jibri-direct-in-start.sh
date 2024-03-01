#!/usr/bin/bash
set -e

# -----------------------------------------------------------------------------
# SIP-Sibri joins the meeting and starts waiting for a direct incoming SIP
# call. There is no SIP server in this scenario.
#
# Call SIP-Jibri by using its SIP address from a remote SIP device.
# e.g. jibri@172.18.18.204
#
# Packages:
#   apt-get install curl jq
#
# Usage:
#   export SELECTOR_HOST="http://172.17.17.1:8015"
#   export JITSI_HOST="https://jitsi.mydomain.corp"
#   export JITSI_ROOM="myroom"
#   export PRIVATE_KEY_FILE="/some-path/asap-signal.key"
#
#   bash sip-jibri-direct-in-start.sh <DISPLAY_NAME>
#
# Example:
#   bash sip-jibri-direct-in-start.sh "sip"
# ------------------------------------------------------------------------------
[[ -z "$PRIVATE_KEY_FILE" ]] && \
  PRIVATE_KEY_FILE="../../files/asap/asap.key" || \
  true

DISPLAY_NAME="$1"
AUTO_ANSWER_TIMEOUT=360

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
      "sipAddress": "sip:jibri@127.0.0.1",
      "displayName": "$DISPLAY_NAME",
      "autoAnswer": true,
      "autoAnswerTimer": $AUTO_ANSWER_TIMEOUT
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
