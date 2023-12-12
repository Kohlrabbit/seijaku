# Variables

Steps can call environment variables, listed in the `variables` dictionary.

Variable values can either be given in the payload (static) or be defined from the executive shell.

```yaml
name: payload with variables

variables:
  ENV_VARIABLE: value
  PROVIDED_ENV_VARIABLE: $PROVIDED_ENV_VARIABLE

tasks:
  - name: do something useful
    steps:
      - sh: echo "sh executor: $ENV_VARIABLE"
      - bash: echo "bash executor: $PROVIDED_ENV_VARIABLE"
```

```bash
export PROVIDED_ENV_VARIABLE=value 
seijaku -f ./docs/variables.yaml
```
