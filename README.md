# blocklist

Wrapper around [StevenBlack's hosts](https://github.com/StevenBlack/hosts) project, with the following features:

- Daemonized; runs on an interval
- Configuration through environment variables

## Running

Example [compose file](https://github.com/docker/compose?tab=readme-ov-file#readme) outlining all options set to their defaults:

```yaml
version: '2'
services:
  blocklist:
    image: ghcr.io/p3lim/blocklist:latest # or pin it to a version
    volumes:
      # this is the output hosts file
      - /path/on/host:/data/hosts
    environment:
      # configurables and their default values
      HOSTS_INTERVAL: 1h # how often it should run, format example: "1d14h3m44s" will run it after 1 day, 14 hours, 3 minutes and 44 seconds
      HOSTS_EXTENSIONS: "" # any additional extensions (see original project readme), defaults to none, comma/space separated string
      HOSTS_IP: 0.0.0.0 # IP address to use as the target in the hosts file
      HOSTS_OUTPUT: /data # configurable output directory, output file will always be named "hosts"
      HOSTS_QUIET: false # limit the log to warnings/errors
```
