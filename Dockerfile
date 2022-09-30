FROM alpine:latest

LABEL name="2022-devopsworld-lab0"

COPY jars/log4j-core-2.17.1.jar  /

RUN set -ex && \
    apk add --no-cache ruby curl jq python3 && \
    python3 -m ensurepip && \
    pip3 install anchorecli && \
    pip3 install --index-url https://pypi.org/simple --no-cache-dir aiohttp==3.7.3 pytest urllib3 botocore six numpy && \
    # curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin  && \
    # curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin && \
    gem install bundler lockbox:0.6.8 ftpd:0.2.1
    
HEALTHCHECK --timeout=10s CMD /bin/true || exit 1

## just to make sure we have a unique build each time 
RUN date > /image_build_timestamp && \
    touch image_build_timestamp_$(date +%Y-%m-%d_%T)
    
USER nobody
ENTRYPOINT /bin/false
