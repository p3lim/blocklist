ARG HOSTS_VERSION=3.14.55
FROM ghcr.io/stevenblack/hosts:$HOSTS_VERSION

RUN apk add --no-cache bash grep

COPY --chmod=0755 entrypoint.sh entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
