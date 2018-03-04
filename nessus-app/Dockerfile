# http://tenable.com
# https://index.docker.io/_/centos/
FROM centos:latest
ENV NESSUS_VERSION="7.0.2"

# https://github.com/sometheycallme
MAINTAINER Tim Kropp <timkropp77@gmail.com>

# Install dependencies.
RUN yum -y update \
      nss-util \
      bind-license \
      libssh2 \
    && yum clean all

RUN set -x \
  # Find the ID
  && DOWNLOAD_ID=$(curl -ssl -o - "https://www.tenable.com/downloads/nessus" | sed -n -e 's/.*data-download-id="\([0-9]*\)".*data-file-name="\([a-zA-Z0-9_\.-]\+\-es7\.x86_64\.rpm\).*".*/\1/p') \
  # Fetch Tenable's GPG key
  && rpm --import https://static.tenable.com/marketing/RPM-GPG-KEY-Tenable \
  # Fetch rpm
  && curl -ssL -o /tmp/Nessus-${NESSUS_VERSION}-es7.x86_64.rpm \
    "https://tenable-downloads-production.s3.amazonaws.com/uploads/download/file/${DOWNLOAD_ID}/Nessus-${NESSUS_VERSION}-es7.x86_64.rpm" \
  # Install rpm and cleanup
  && rpm -ivh /tmp/Nessus-${NESSUS_VERSION}-es7.x86_64.rpm \
  && rm /tmp/Nessus-${NESSUS_VERSION}-es7.x86_64.rpm \
  && yum clean all \
  && rm -rf /var/cache/yum

EXPOSE 8834
CMD ["/opt/nessus/sbin/nessus-service"]
