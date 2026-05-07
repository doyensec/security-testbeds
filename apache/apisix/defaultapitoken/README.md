# Apache APISIX Default API Token


This directory contains the deployment configs for an Apache APISIX installation
Apache APISIX has a built-in default API KEY. If the user does not proactively modify it (which few will), Lua scripts
can be executed directly through the API interface, which can lead to RCE vulnerabilities. Normally, the admin API endpoints are restricted by the client IP address, but this tests for a case where other IP addresses have been allowed. See the `allow_admin` part of the configuration files.

You can start both the vulnerable service and safe service by running the command `docker compose up -d`. The vulnerable container listens on port `8081`, and the safe container listens on port `8082`.

In this case, the vulnerable service uses APISIX with the default API key, and the safe service uses APISIX with a changed API key using the `config_api_key_change.yml` file.
