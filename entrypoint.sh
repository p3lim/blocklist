#!/bin/bash

# fail on errors
set -eo pipefail

# respect termination
trap 'exit' SIGINT SIGTERM

interval="${HOSTS_INTERVAL:-1h}"

# translate interval string to seconds
seconds=0
while read -r var; do
  # grab the integer
  n="${var//[dhms]/}"

  # convert the interval section to seconds
  case "$var" in
    *d) ((seconds += (n * 86400))) ;;
    *h) ((seconds += (n * 3600))) ;;
    *m) ((seconds += (n * 60))) ;;
    *s) ((seconds += n)) ;;
  esac

  # remove var from original string
  interval="${interval//$var/}"
done < <(grep -Po '([0-9]+[dhms])' <<< "$interval")

# if the interval still contains values we need to throw an error
if [ "z$interval" != 'z' ]; then
  echo 'invalid interval'
  exit 1
fi

extensions=
if [ "z$HOSTS_EXTENSIONS" != 'z' ]; then
  # support different separators
  extensions="${HOSTS_EXTENSIONS//,/ }"

  # prefix
  extensions="--extensions $extensions"
fi

if [ "${HOSTS_QUIET,,}" = 'true' ]; then
  # void stdout
  exec >/dev/null
fi

# infinite loop
while true; do
  # run update given overridable parameters
  python3 /hosts/updateHostsFile.py \
    --auto \
    --output "${HOSTS_OUTPUT:-/data}" \
    --ip "${HOSTS_IP:-0.0.0.0}" \
    --minimise $extensions &
  wait # use subshells so we can interrupt the process with SIGINT

  # wait for next interval
  echo "sleeping, next run in ${HOSTS_INTERVAL:-6h} ($seconds seconds)"
  sleep $seconds &
  wait # use subshells so we can interrupt the sleep with SIGINT
done
