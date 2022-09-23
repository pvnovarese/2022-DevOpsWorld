FROM alpine:latest

LABEL name="2022-devopsworld-lab0"

COPY jars/log4j-core-2.14.1.jar  /

RUN set -ex && \
    apk add --no-cache ruby curl jq && \
    gem install bundler lockbox:0.6.8 ftpd:0.2.1 && \
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin && \
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

HEALTHCHECK --timeout=10s CMD /bin/true || exit 1
USER nobody
ENTRYPOINT /bin/false
