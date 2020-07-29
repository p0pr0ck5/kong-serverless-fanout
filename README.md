# kong-serverless-fanout

POC to demonstrate using Kong API gateway as a fanout executor

# Synopsis

This is a quick hack to demonstrate using Kong's DBless mode and serverless
plugins to serve as a fanout executor. An instance of Kong, and several
instances of a simple upstream service (`httpbin`) are created through
`docker-compose`. A catch-all Route is created in Kong, along with a
`pre-function` plugin. The contents of the plugin are executed in the `access`
phase, meaning the function logic will run before (and short-circuit) the native
Nginx proxy_pass handler.

# Usage

## Requirements

* docker
* docker-compose
* make
* perl

## Setup

```bash
$ make
```

## Teardown

```bash
$ make down
```
