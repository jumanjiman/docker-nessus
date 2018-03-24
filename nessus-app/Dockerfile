# http://tenable.com
# https://index.docker.io/_/centos/
FROM centos:7
ARG NESSUS_VERSION

# https://github.com/sometheycallme
MAINTAINER Tim Kropp <timkropp77@gmail.com>

# Install dependencies.
RUN yum -y update \
      nss-util \
      bind-license \
      libssh2 \
      && \
    yum clean all \
      && \
    rm -fr /var/cache/yum
COPY tenable-2048.gpg /tmp
COPY Nessus-7.0.3-es7.x86_64.rpm /tmp
RUN rpm --import /tmp/tenable-2048.gpg
RUN (yum -y localinstall /tmp/Nessus-7.0.3-es7.x86_64.rpm || \
    yum -y localinstall /tmp/Nessus-7.0.3-es7.x86_64.rpm) && \
    yum clean all

EXPOSE 8834
CMD ["/opt/nessus/sbin/nessus-service"]
