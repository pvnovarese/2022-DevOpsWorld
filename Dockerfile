FROM alpine:latest

RUN set -ex && \
    apk add --no-cache ruby curl && \
    gem install bundler lockbox:0.6.8 ftpd:0.2.1 

USER nobody
ENTRYPOINT /bin/false
