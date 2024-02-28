# jitsi-component-selector

## Run

```bash
# to simulate ASAP key server
python3 -m http.server -d ../files/asap 8000

docker run \
  -p 8015:8015 \
  -e REDIS_HOST=172.17.17.1 \
  -e PROTECTED_SIGNAL_API=false \
  jitsi-component-selector
```

## Environment variables

See
[env.example](https://github.com/jitsi/jitsi-component-selector/blob/main/env.example)
and
[config.ts](https://github.com/jitsi/jitsi-component-selector/blob/main/src/config/config.ts)
for the list.
