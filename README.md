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

## Usage

The function will wrap responses in JSON, as an array of objects:

```json
[
  {
    "response": {...},
    "node": "...",
    "err": "...",
  }...
]
```

```bash
$ curl -s localhost:8000/get?foo=bar | jq
[
  {
    "response": {
      "origin": "192.168.80.4",
      "headers": {
        "User-Agent": "curl/7.58.0",
        "Accept": "*/*",
        "Host": "localhost:8000"
      },
      "url": "http://localhost:8000/get?foo=bar",
      "args": {
        "foo": "bar"
      }
    },
    "node": "192.168.80.3"
  },
  {
    "response": {
      "origin": "192.168.80.4",
      "headers": {
        "User-Agent": "curl/7.58.0",
        "Accept": "*/*",
        "Host": "localhost:8000"
      },
      "url": "http://localhost:8000/get?foo=bar",
      "args": {
        "foo": "bar"
      }
    },
    "node": "192.168.80.5"
  },
  {
    "response": {
      "origin": "192.168.80.4",
      "headers": {
        "User-Agent": "curl/7.58.0",
        "Accept": "*/*",
        "Host": "localhost:8000"
      },
      "url": "http://localhost:8000/get?foo=bar",
      "args": {
        "foo": "bar"
      }
    },
    "node": "192.168.80.2"
  }
]
```

## Teardown

```bash
$ make down
```

## Notes

Don't use this.
