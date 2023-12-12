# SSH

Since version `0.1.0`, Seijaku implements a SSH step executor. Only one SSH host can be set per task.


```yaml
name: payload with SSH executor

ssh:
  - host: my-host
    port: 22
    user: ubuntu

tasks:
  - name: do something useful
    host: my-host
    steps:
      - ssh: echo "connection test"
```

It is recommended to run `ssh-add` before running Seijaku, as each step would require you to enter your password.

## Variables

Variables can be set from the Seijaku executive host and ran in the SSH host context:

```yaml
name: payload with SSH executor (variables)

ssh:
  - host: my-host
    port: 22
    user: ubuntu

variables:
  ENV_VARIABLE: value
  PROVIDED_ENV_VARIABLE: $PROVIDED_ENV_VARIABLE

tasks:
  - name: do something useful
    host: my-host
    steps:
      - ssh: echo "connection test"
      - ssh: echo "$ENV_VARIABLE"
      - ssh: echo "$PROVIDED_ENV_VARIABLE"
```

## Bastion / Jump host / Proxy

You sometimes need to jump over a publicly exposed server to reach another one. Seijaku supports SSH Proxy, with a maximum of 1 hop.

```yaml
name: payload with SSH executor (bastion)

ssh:
  - host: bastion-host
    port: 22
    user: bastion_user

  - host: my-host
    port: 22
    user: ubuntu
    bastion: bastion-host

variables:
  ENV_VARIABLE: value
  PROVIDED_ENV_VARIABLE: $PROVIDED_ENV_VARIABLE

tasks:
  - name: do something useful
    host: my-host
    steps:
      - ssh: echo "connection test"
      - ssh: echo "$ENV_VARIABLE"
      - ssh: echo "$PROVIDED_ENV_VARIABLE"
```

The `ssh.[].host` must be a reachable address (domain name or IP).
