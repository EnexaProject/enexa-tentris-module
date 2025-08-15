# Don't change this file! It is generated based on Dockerfile.template.
FROM hub.cs.upb.de/enexa/images/enexa-utils:1-debug2 AS utils

FROM alpine:3.20
RUN apk add --no-cache curl
RUN curl --version && echo "CURL INSTALLED OK"

WORKDIR /app

COPY --from=utils / /
COPY tentris /app/tentris_server
COPY module /app/module

ENTRYPOINT ["./module"]
