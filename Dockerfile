FROM ghcr.io/stevenblack/hosts:3.14.31

RUN apk add --no-cache bash grep

COPY --chmod=0755 entrypoint.sh entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
