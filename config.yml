_format_version: "2.1"
_transform: true

services:
- name: my-service
  url: http://httpbin
  plugins:
  - name: pre-function
    config:
      access:
        - |
{fanout}
  routes:
  - name: my-route
    paths:
    - /
