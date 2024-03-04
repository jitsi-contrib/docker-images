# sip-jibri

## Run

```bash
docker pull ghcr.io/jitsi-contrib/docker-images/sip-jibri:latest

docker run \
  -e PUBLIC_URL='https://jitsi.mydomain.corp' \
  -e XMPP_SERVER='jitsi.mydomain.corp' \
  -e JIBRI_XMPP_PASSWORD='jibriXmppPassword' \
  -e SIP_JIBRI_XMPP_PASSWORD='sipjibriXmppPassword' \
  -v /tmp/config:/config \
  ghcr.io/jitsi-contrib/docker-images/sip-jibri
```

## Build and Run

```bash
git clone https://github.com/jitsi-contrib/docker-images.git
cd docker-images/sip-jibri

docker image build -t sip-jibri .

docker run \
  -e PUBLIC_URL='https://jitsi.mydomain.corp' \
  -e XMPP_SERVER='jitsi.mydomain.corp' \
  -e JIBRI_XMPP_PASSWORD='jibriXmppPassword' \
  -e SIP_JIBRI_XMPP_PASSWORD='sipjibriXmppPassword' \
  -v /tmp/config:/config \
  sip-jibri
```

## Sponsors

[![Nordeck](/images/nordeck.png)](https://nordeck.net/)
