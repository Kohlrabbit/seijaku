# Schedulers

Since version `0.3.0`, Seijaku implements a task scheduler that permits us to execute payloads with interval between two runs.

Instead of using the `-f` parameter to run a payload, you can use the `-s (--scheduler)` parameter to pass a `schedulerfile` to Seijaku.

## How it works ?

Ruby isn't great at parallelism, but it does integrate `Threads`. The Scheduler will assign a Thread to all the payloads to execute.

## Example

Here is a really basic payload for example purpose:

```yaml
name: my-payload
tasks:
  - name: say hello world
    steps:
      - sh: echo "hello world"
```

If you want to run this payload every 10 seconds, you can create a scheduler file (call it whatever you want), describing the awaited behavior.

```yaml
name: "my-scheduler"

payloads:
  - payload: ./my-payload.yaml
    every: 10
    name: say-hello-world-10-s
```

## Graceful stop

CTRL+C (Interrupt signal) sends an information to all the SchedulerExecutors running, asking them to do not re-schedule the payload execution they are in charge of once the current execution is finished.

```
...
> CTRL+C
[2023-12-14T18:48:12.509483 #8841]  INFO -- : Soft exit asked by user, waiting for payloads to stop naturally...
I, [2023-12-14T18:48:12.509789 #8841]  INFO -- : test payload: still waiting...
I, [2023-12-14T18:48:12.509856 #8841]  INFO -- : another-payload: still waiting...
I, [2023-12-14T18:48:13.515211 #8841]  INFO -- : test payload: still waiting...
I, [2023-12-14T18:48:13.515496 #8841]  INFO -- : another-payload: still waiting...
I, [2023-12-14T18:48:14.520005 #8841]  INFO -- : test payload: still waiting...
I, [2023-12-14T18:48:14.520262 #8841]  INFO -- : another-payload: stopped gracefully.
I, [2023-12-14T18:48:15.524617 #8841]  INFO -- : test payload: stopped gracefully.
All payloads did stop their execution gracefully.
```

## Work in progress

* at the moment, only `every` is accepted. Cron formulas could one day be an option but its implementation is more complex.
