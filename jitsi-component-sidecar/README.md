# jitsi-component-sidecar

## Run

```bash
docker run \
  -e COMPONENT_TYPE=JIBRI \
  -e ENABLE_STOP_INSTANCE=true \
  -e WS_SERVER_URL=ws://selector:8015 \
  -e ASAP_SIGNING_KEY_FILE=/app/asap.key \
  -v ${PWD}/../files/asap/asap.key:/app/asap.key \
  jitsi-component-sidecar
```
