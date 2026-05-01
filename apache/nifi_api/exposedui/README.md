# Vulnerable Apache NiFi API with Exposed UI

This directory contains the deployment configs for a vulnerable Apache NiFi API
version (1.12.0).

The deployed service has name `apache-nifi-api` and listens on port `8080`.

## Docker Compose
```
docker compose up
```
Vulnerable service (no authentication) will be on port 8081
Safe service (authentication using single-user credentials) will be on port 8082

## Testing the vulnerability
```
curl localhost:8081/nifi-api/access/config
```
Response:
```
{"config":{"supportsLogin":false}}
```
