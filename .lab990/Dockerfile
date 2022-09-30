FROM xmrig/xmrig:latest AS xmrig

FROM docker.io/redhat/ubi8-minimal:latest

COPY --from=xmrig /xmrig/xmrig /xmrig/xmrig


#FROM alpine:latest
#
#LABEL name="2022-devopsworld-lab0"
#
#RUN set -ex && \
#    apk add --no-cache ruby curl jq python3 && \
#    python3 -m ensurepip && \
#    pip3 install anchorecli && \
#    pip3 install --index-url https://pypi.org/simple --no-cache-dir pytest urllib3 botocore six && \
#    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin  && \
#    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin && \
#    gem install bundler lockbox:0.6.8 ftpd:0.2.

RUN set -ex && \
    microdnf -y install ruby python3-devel python3 python3-pip nodejs shadow-utils tar gzip sudo && \
    curl -sSfL  https://anchorectl-releases.anchore.io/anchorectl/install.sh  | sh -s -- -b /usr/local/bin && \
    adduser -d /xmrig mining && \
    pip3 install --index-url https://pypi.org/simple --no-cache-dir pytest urllib3 botocore six numpy && \
    gem install bundler lockbox:0.6.8 ftpd:0.2.1 && \
    npm install -g --cache /tmp/empty-cache debug chalk commander xmldom@0.4.0 && \
    npm cache clean --force && \
    microdnf -y clean all && \
    rm -rf /var/cache/yum /tmp 
    
HEALTHCHECK --timeout=10s CMD /bin/true || exit 1

## just to make sure we have a unique build each time 
RUN date > /image_build_timestamp && \
    touch image_build_timestamp_$(date +%Y-%m-%d_%T)
    
USER mining
WORKDIR /xmrig
ENTRYPOINT /bin/false
