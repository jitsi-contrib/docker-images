# sip-jibri

## Run

- Assumed that `snd_aloop` is loaded and configured correctly on host.
- Assumed that `v4l2loopback` is loaded and configured correctly on host.

```bash
docker pull ghcr.io/jitsi-contrib/docker-images/sip-jibri:latest

docker run \
  -e PUBLIC_URL=https://jitsi.mydomain.corp \
  -e XMPP_SERVER=jitsi.mydomain.corp \
  -e JIBRI_XMPP_PASSWORD=jibriXmppPassword \
  -e SIP_JIBRI_XMPP_PASSWORD=sipjibriXmppPassword \
  -e CHROMIUM_FLAGS='--use-fake-ui-for-media-stream,--start-maximized,--kiosk,--enabled,--autoplay-policy=no-user-gesture-required' \
  --shm-size=2gb \
  --cap-add=SYS_ADMIN \
  --device=/dev/snd:/dev/snd \
  --device=/dev/video10:/dev/video0 \
  --device=/dev/video11:/dev/video1 \
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
  --shm-size=2gb \
  --cap-add=SYS_ADMIN \
  --device=/dev/snd:/dev/snd \
  --device=/dev/video10:/dev/video0 \
  --device=/dev/video11:/dev/video1 \
  -v /tmp/config:/config \
  sip-jibri
```

## Environment variables

Check [templates](rootfs/defaults) for possible environment variables.

## Notes

### snd-aloop

Two ALSA loopback devices should be available for each `sip-jibri`.

An example `/etc/modprobe.d/alsa-loopback.conf`:

```
options snd-aloop enable=1,1 index=2,3
```

You should also load the kernel module:

```bash
modprobe snd-aloop
```

### v4l2loopback

Two `v4l2loopback` devices should be available for each `sip-jibri`.

An example `/etc/modprobe.d/v4l2loopback.conf`:

```
options v4l2loopback video_nr=10,11 exclusive_caps=1,1
```

You should also load the kernel module:

```bash
modprobe v4l2loopback
```

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
  --shm-size=2gb \
  --cap-add=SYS_ADMIN \
  --device=/dev/snd:/dev/snd \
  --device=/dev/video10:/dev/video0 \
  --device=/dev/video11:/dev/video1 \
  -v /tmp/config:/config \
  ghcr.io/jitsi-contrib/docker-images/sip-jibri
```

### Self-signed certificate

If `Jitsi` has not a trusted certificate, add `--ignore-certificate-errors` into
`CHROMIUM_FLAGS`:

```
-e CHROMIUM_FLAGS='--ignore-certificate-errors,--use-fake-ui-for-media-stream,--start-maximized,--kiosk,--enabled,--autoplay-policy=no-user-gesture-required'
```

### SIP parameters

If you need to set a permanent SIP account for `sip-jibri`, set the following
environment variables:

```bash
-e SIP_ID='jitsi <sip:1001@sip.mydomain.corp>' \
-e SIP_REGISTRAR='sip:sip.mydomain.corp' \
-e SIP_REALM='*' \
-e SIP_USERNAME=1001 \
-e SIP_PASSWORD=mysippassword \
```

If SIP credentials are set dynamically in API requests, no need to set these
parameters.

## Sponsors

[![Nordeck](/images/nordeck.png)](https://nordeck.net/)
