# sip-jibri

## Run

```bash
docker pull ghcr.io/jitsi-contrib/docker-images/sip-jibri:latest

docker run \
  -e PUBLIC_URL=https://jitsi.mydomain.corp \
  -e XMPP_SERVER=jitsi.mydomain.corp \
  -e JIBRI_XMPP_PASSWORD=jibriXmppPassword \
  -e SIP_JIBRI_XMPP_PASSWORD=sipjibriXmppPassword \
  -e CHROMIUM_FLAGS='--use-fake-ui-for-media-stream,--start-maximized,--kiosk,--enabled,--autoplay-policy=no-user-gesture-required' \
  -v /tmp/config:/config \
  ghcr.io/jitsi-contrib/docker-images/sip-jibri
```

## Build and Run

```bash
git clone https://github.com/jitsi-contrib/docker-images.git
cd docker-images/sip-jibri

docker image build -t sip-jibri .

docker run \
  -e PUBLIC_URL=https://jitsi.mydomain.corp \
  -e XMPP_SERVER=jitsi.mydomain.corp \
  -e JIBRI_XMPP_PASSWORD=jibriXmppPassword \
  -e SIP_JIBRI_XMPP_PASSWORD=sipjibriXmppPassword \
  -e CHROMIUM_FLAGS='--use-fake-ui-for-media-stream,--start-maximized,--kiosk,--enabled,--autoplay-policy=no-user-gesture-required' \
  -v /tmp/config:/config \
  sip-jibri
```

## Notes

### Running with a standalone Jitsi

If `Jitsi` is not running as a container, extra parameters should be set for
`sip-jibri`:

```bash
docker run \
  -e PUBLIC_URL=https://jitsi.mydomain.corp \
  -e XMPP_SERVER=jitsi.mydomain.corp \
  -e JIBRI_XMPP_PASSWORD=jibriXmppPassword \
  -e SIP_JIBRI_XMPP_PASSWORD=sipjibriXmppPassword \
  -e CHROMIUM_FLAGS='--use-fake-ui-for-media-stream,--start-maximized,--kiosk,--enabled,--autoplay-policy=no-user-gesture-required' \
  -e SIP_JIBRI_BREWERY_MUC=SipBrewery \
  -e XMPP_DOMAIN=jitsi.mydomain.corp \
  -e XMPP_SIP_DOMAIN=sip.jitsi.mydomain.corp \
  -e XMPP_AUTH_DOMAIN=auth.jitsi.mydomain.corp \
  -e XMPP_MUC_DOMAIN=conference.jitsi.mydomain.corp \
  -e XMPP_INTERNAL_MUC_DOMAIN=internal.auth.jitsi.mydomain.corp \
  -v /tmp/config:/config \
  ghcr.io/jitsi-contrib/docker-images/sip-jibri
```

### Self-signed certificate

If `Jitsi` has not a trusted certificate, add `--ignore-certificate-errors` into
`CHROMIUM_FLAGS`:

```
-e CHROMIUM_FLAGS='--ignore-certificate-errors,--use-fake-ui-for-media-stream,--start-maximized,--kiosk,--enabled,--autoplay-policy=no-user-gesture-required'
```

## Sponsors

[![Nordeck](/images/nordeck.png)](https://nordeck.net/)
