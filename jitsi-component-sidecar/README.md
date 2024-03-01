# jitsi-component-sidecar

## Clone

```bash
git clone https://github.com/jitsi-contrib/docker-images.git
cd docker-images/jitsi-component-sidecar
```

## Run

- This service needs `asap.key`. See [ASAP](/files/asap) for more details.
- This service needs `jitsi-component-selector` service.
- Assumed that `jitsi-component-selector`'s IP address is `172.17.17.1`.

Run the following commands in this folder because there is a reference to
`asap.key` file:

```bash
docker pull ghcr.io/jitsi-contrib/docker-images/jitsi-component-sidecar:latest

docker run \
  -e COMPONENT_TYPE='SIP-JIBRI' \
  -e ENABLE_STOP_INSTANCE=true \
  -e WS_SERVER_URL='ws://172.17.17.1:8015' \
  -e ASAP_SIGNING_KEY_FILE=/app/asap.key \
  -v ${PWD}/../files/asap/asap.key:/app/asap.key \
  ghcr.io/jitsi-contrib/docker-images/jitsi-component-sidecar
```

## Build and Run

```bash
docker image build -t jitsi-component-sidecar .

docker run \
  -e COMPONENT_TYPE=SIP-JIBRI \
  -e ENABLE_STOP_INSTANCE=true \
  -e WS_SERVER_URL=ws://172.17.17.1:8015 \
  -e ASAP_SIGNING_KEY_FILE=/app/asap.key \
  -v ${PWD}/../files/asap/asap.key:/app/asap.key \
  jitsi-component-sidecar
```

## Environment variables

See
[env.example](https://github.com/jitsi/jitsi-component-sidecar/blob/main/env.example)
and
[config.ts](https://github.com/jitsi/jitsi-component-sidecar/blob/main/src/config/config.ts)
for the list.

## Notes

### External Jibri

Use `jitsi-component-sidecar` as a sidecar container if your environment allows
this usage. So, `jitsi-component-sidecar` can access `Jibri`'s API through
`localhost`. No need to set endpoints in this case.

If `Jibri`'s API is not accessible through `localhost`, set the related
environment variables to point to endpoints. Assumed that `Jibri`'s IP is
`172.18.18.204` in the following example:

```bash
docker run \
   -e STATS_RETRIEVE_URL=http://172.18.18.204:2222/jibri/api/v1.0/health \
   -e START_INSTANCE_URL=http://172.18.18.204:2222/jibri/api/v1.0/startService \
   -e STOP_INSTANCE_URL=http://172.18.18.204:2222/jibri/api/v1.0/stopService \
   ...
   ...
   jitsi-component-sidecar
```

## Sponsors

[![Nordeck](/images/nordeck.png)](https://nordeck.net/)
