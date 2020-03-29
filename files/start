#!/bin/sh
#
# Docker entrypoint
#

# Ensure up-to-date
/etc/periodic/daily/get_iplayer_update

# Start cron with output to syslog
/sbin/syslogd
/usr/sbin/crond

# Restart if killed, e.g. due to update
umask 2
while true; do
    /usr/local/bin/get_iplayer --verbose
    if [ -z "$BASEURL" ]; then
        su-exec $PUID:$PGID /usr/local/bin/get_iplayer.cgi -p $PORT | grep -v "^DEBUG:";
    else
        su-exec $PUID:$PGID /usr/local/bin/get_iplayer.cgi -p $PORT -b "$BASEURL" | grep -v "^DEBUG:";
    fi
done
