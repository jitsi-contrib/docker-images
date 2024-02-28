# jitsi-component-sidecar

## Run

```bash
docker run \
  -e COMPONENT_TYPE=jibri \
  -e ASAP_SIGNING_KEY_FILE=/app/asap.key \
  -v ${PWD}/../files/asap/asap.key:/app/asap.key \
  jitsi-component-sidecar
```
