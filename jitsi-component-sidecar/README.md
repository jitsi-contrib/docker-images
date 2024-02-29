# jitsi-component-sidecar

## Run

- This service needs `asap.key`. See [asap](/files/asap) for more details.
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
  -e COMPONENT_TYPE='SIP-JIBRI' \
  -e ENABLE_STOP_INSTANCE=true \
  -e WS_SERVER_URL='ws://172.17.17.1:8015' \
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
