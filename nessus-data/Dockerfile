# Nessus Data Volume
#
FROM scratch
MAINTAINER Tim Kropp "timkropp77@gmail.com"
# copy over unlicensed nessus app data for startup
COPY var /opt/nessus/var
COPY etc /opt/nessus/etc
COPY sbin /opt/nessus/sbin
# use that data as a volume for startup
VOLUME /opt/nessus/var
VOLUME /opt/nessus/etc
VOLUME /opt/nessus/sbin
