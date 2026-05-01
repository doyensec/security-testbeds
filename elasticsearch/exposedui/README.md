# Elasticsearch Exposed UI Testbed

## Vulnerable
docker run -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:tag

## Docker Compose
```
docker compose up
```
Vulnerable service will be at http://localhost:8081/
Safe service will be at http://localhost:8082/

