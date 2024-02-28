# ASAP KEY

```bash
openssl genrsa -out asap.key 4096
openssl rsa -in asap.key -pubout -outform PEM -out asap.pem
```
