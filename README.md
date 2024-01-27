# Seijaku

[![Seijaku version](https://badge.fury.io/rb/seijaku.svg)](https://badge.fury.io/rb/seijaku)

Seijaku is a program that allows you to execute shell commands listed in YAML payload files, ensuring that they are executed correctly.
It includes a lightweight scheduler that will take care of executing payloads with specific delay between two executions.

## Concepts

Payloads are YAML files that describe the various tasks Seijaku will have to perform (in order). Each task contains one or more steps.

A step is a shell command to be executed. Seijaku currently supports the following shells: bash, sh and ssh.

Each task can have "pre" and "post" tasks, for example to create and delete folders, or install and uninstall software needed to run a task.

A step sometimes needs variables in order to be performed correctly: Seijaku supports the direct definition of variables or from an environment variable of the shell running Seijaku.

A scheduler is a file listing payloads that must be executed with unique specifications: a name, a delay between two runs and the path to the concerned payload.

## Example

```yaml
name: my payload

ssh:
  - host: my-host
    user: user
    port: 22

variables:
  MY_VARIABLE: a static variable
  MY_ENV_VARIABLE: $MY_ENV_VARIABLE

tasks:
  - name: do something useful
    steps:
      - sh: echo "$MY_VARIABLE"		# "a static variable"
      - bash: echo "$MY_ENV_VARIABLE"	# given from executive shell

  - name: task with more settings
    pre:
      - sh: "do something before"
    steps:
      - sh: echo "$MY_VARIABLE"
        output: true
      - sh: echo "something" && exit 1
        soft_fail: true
    post:
      - sh: "do something after"
  
  - name: task with SSH executor
    host: my-host
    steps:
      - ssh: echo "executed on host"
```

### Scheduler

```yaml
name: my-scheduler

payloads:
  - payload: ./test/my-payload.yaml
    name: My test Payload
    every: 3600				# executed every hour

  - payload: ./test/another-payload.yaml
    name: Another payload
    every: 60				# executed every minute
```

## Installation

### Dependencies

* Ruby 2.5+
* Rubygem

Install Seijaku using Gem:

```bash
gem install seijaku
```

## Usage

```bash
seijaku -h
seijaku -f ./my-payload.yaml # one-time payload execution
seijaku -s ./my-scheduler.yaml # recurrent payloads execution with delay
```
