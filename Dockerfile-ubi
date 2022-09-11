FROM docker.io/redhat/ubi8-minimal:latest

RUN set -ex && \
    microdnf -y install ruby python3-devel python3 python3-pip nodejs shadow-utils tar gzip && \
    pip3 install --index-url https://pypi.org/simple --no-cache-dir aiohttp==3.7.3 pytest urllib3 botocore six numpy && \
    gem install bundler lockbox:0.6.8 ftpd:0.2.1 && \
    npm install -g --cache /tmp/empty-cache debug chalk commander xmldom@0.4.0 && \
    npm cache clean --force && \
    microdnf -y clean all && \
    rm -rf /var/cache/yum /tmp

USER nobody
ENTRYPOINT /bin/false
