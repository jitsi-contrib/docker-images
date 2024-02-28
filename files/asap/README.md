# ASAP KEY

## Generating keys

```bash
openssl genrsa -out asap.key 4096
openssl rsa -in asap.key -pubout -outform PEM -out asap.pem
```

## Key server

```bash
KID_SIDECAR="jitsi/default"
HASH=$(echo -n "$KID_SIDECAR" | sha256sum | awk '{print $1}')

mkdir server
cp asap.pem server/$HASH.pem

python3 -m http.server
```
