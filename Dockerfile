FROM alpine:latest
MAINTAINER Jonathan Harris <jonathan@marginal.org.uk>
EXPOSE 1935
ENV GETIPLAYER_OUTPUT=/output GETIPLAYER_PROFILE=/output/.get_iplayer
VOLUME "$GETIPLAYER_OUTPUT"

# Output file ownership
ENV PUID=1000 PGID=100

RUN apk --update --no-cache add ffmpeg perl-cgi perl-mojolicious perl-lwp-protocol-https perl-xml-libxml logrotate

RUN wget -qnd "https://bitbucket.org/shield007/atomicparsley/raw/68337c0c05ec4ba2ad47012303121aaede25e6df/downloads/build_linux_x86_64/AtomicParsley" && install -m 755 -t /usr/local/bin ./AtomicParsley && rm ./AtomicParsley

RUN wget -qO - `wget -qO - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" | grep "tarball_url" | cut -d'"' -f4` | tar -zxf - && cd `ls -d get-iplayer*` && install -m 755 -t /usr/local/bin ./get_iplayer ./get_iplayer.cgi && cd / && rm -rf get-iplayer*

COPY pvr /etc/periodic/hourly/get_iplayer_pvr
COPY update /etc/periodic/daily/get_iplayer_update
COPY logrotate /etc/logrotate.d/get_iplayer

CMD (crond; umask 2; exec get_iplayer.cgi -p 1935)
