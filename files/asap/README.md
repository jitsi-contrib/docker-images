# ASAP Key

## Generating keys

```bash
openssl genrsa -out asap.key 4096
openssl rsa -in asap.key -pubout -outform PEM -out asap.pem
```

## Simulating ASAP key server

```bash
mkdir server
KID_SIDECAR="jitsi/default"
HASH=$(echo -n "$KID_SIDECAR" | sha256sum | awk '{print $1}')
cp asap.pem server/$HASH.pem

mkdir signal
KID_SIGNAL="jitsi/signal"
HASH=$(echo -n "$KID_SIGNAL" | sha256sum | awk '{print $1}')
cp asap.pem signal/$HASH.pem

python3 -m http.server 8000
```
