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

COPY install-nessus.sh /usr/sbin/
RUN /usr/sbin/install-nessus.sh

EXPOSE 8834
CMD ["/opt/nessus/sbin/nessus-service"]
