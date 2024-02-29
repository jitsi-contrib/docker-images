# jitsi-component-selector

## Run

- This service needs `Redis` and `ASAP key server`.
- Assumed that the host IP is `172.17.17.1`.

Run the following in this folder but in a different shell to simulate ASAP key
server.

```bash
python3 -m http.server -d ../files/asap 8000
```

```bash
docker run -d -p 6379:6379 redis

docker pull ghcr.io/jitsi-contrib/docker-images/jitsi-component-selector:latest

docker run \
  -p 8015:8015 \
  -e REDIS_HOST=172.17.17.1 \
  -e PROTECTED_SIGNAL_API=true \
  -e SYSTEM_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "http://172.17.17.1:8000/server"}]' \
  -e SIGNAL_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "http://172.17.17.1:8000/signal"}]' \
  ghcr.io/jitsi-contrib/docker-images/jitsi-component-selector
```

## Build and Run

```bash
docker image build -t jitsi-component-selector .

docker run \
  -p 8015:8015 \
  -e REDIS_HOST=172.17.17.1 \
  -e PROTECTED_SIGNAL_API=true \
  -e SYSTEM_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "http://172.17.17.1:8000/server"}]' \
  -e SIGNAL_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "http://172.17.17.1:8000/signal"}]' \
  jitsi-component-selector
```

## Environment variables

See
[env.example](https://github.com/jitsi/jitsi-component-selector/blob/main/env.example)
and
[config.ts](https://github.com/jitsi/jitsi-component-selector/blob/main/src/config/config.ts)
for the list.
