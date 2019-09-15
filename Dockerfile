FROM alpine:latest
MAINTAINER Jonathan Harris <jonathan@marginal.org.uk>
ENV GETIPLAYER_OUTPUT=/output GETIPLAYER_PROFILE=/output/.get_iplayer PUID=1000 PGID=100 PORT=1935
EXPOSE $PORT
VOLUME "$GETIPLAYER_OUTPUT"

RUN apk --update --no-cache add ffmpeg perl-cgi perl-mojolicious perl-lwp-protocol-https perl-xml-libxml jq logrotate su-exec tini

RUN wget -qnd "https://bitbucket.org/shield007/atomicparsley/raw/68337c0c05ec4ba2ad47012303121aaede25e6df/downloads/build_linux_x86_64/AtomicParsley" && \
    install -m 755 -t /usr/local/bin ./AtomicParsley && \
    rm ./AtomicParsley

RUN wget -qO - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" > /tmp/latest.json && \
    echo get_iplayer release `jq -r .name /tmp/latest.json` && \
    wget -qO - "`jq -r .tarball_url /tmp/latest.json`" | tar -zxf - && \
    cd get-iplayer* && \
    install -m 755 -t /usr/local/bin ./get_iplayer ./get_iplayer.cgi && \
    cd / && \
    rm -rf get-iplayer* && \
    rm /tmp/latest.json

COPY files/ /

ENTRYPOINT ["/sbin/tini", "--"]
CMD /start
