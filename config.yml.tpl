_format_version: "2.1"
_transform: true

routes:
- name: my-route
  paths:
  - /
  plugins:
  - name: pre-function
    config:
      access:
        - |
{fanout}
