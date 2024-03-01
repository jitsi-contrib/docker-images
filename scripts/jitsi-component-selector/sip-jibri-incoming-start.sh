#!/usr/bin/bash
set -e

# -----------------------------------------------------------------------------
# SIP-Sibri joins the meeting and starts waiting for an incoming SIP call.
#
# Call SIP-Jibri by using its SIP address from a remote SIP device.
# e.g. 1009@sip.mydomain.corp
#
# Use the IP address of SIP server in INVITER_CONTACT.
#
# Packages:
#   apt-get install curl jq
#
# Usage:
#   export SELECTOR_HOST="http://172.17.17.1:8015"
#   export JITSI_HOST="https://jitsi.mydomain.corp"
#   export JITSI_ROOM="myroom"
#   export INVITER_USERNAME="1009@sip.mydomain.corp"
#   export INVITER_PASSWORD="1234"
#   export INVITER_CONTACT="<sip:1009@172.17.17.36:5060;transport=udp>"
#   export PRIVATE_KEY_FILE="/some-path/asap-signal.key"
#
#   bash sip-jibri-incoming-start.sh <INVITEE>
#
# Example:
#   bash sip-jibri-incoming-start.sh "sip:1001@sip.mydomain.corp"
# ------------------------------------------------------------------------------
[[ -z "$PRIVATE_KEY_FILE" ]] && \
  PRIVATE_KEY_FILE="../../files/asap/asap.key" || \
  true

INVITEE="$1"

[[ -z "$DISPLAY_NAME" ]] && \
  DISPLAY_NAME=$(echo $INVITEE | cut -d: -f2 | cut -d@ -f1) || \
  true

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
      "userName": "$INVITER_USERNAME",
      "password": "$INVITER_PASSWORD",
      "contact": "$INVITER_CONTACT",
      "sipAddress": "$INVITEE",
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
