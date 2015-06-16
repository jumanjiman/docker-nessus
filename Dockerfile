# http://tenable.com
# https://index.docker.io/_/centos/
FROM centos

# https://github.com/sometheycallme
MAINTAINER Tim Kropp <timkropp77@gmail.com>

# https://github.com/sometheycallme
MAINTAINER Tim Kropp <timkropp77@gmail.com>

# Update the base image.
# RUN yum -y update

# Install dependencies.
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Get splunk RPM
# requires splunk account
ADD http://downloads.nessus.org/nessus3dl.php?file=Nessus-6.3.7-es6.i386.rpm&licence_accept=yes&t=9bdd4aaf6bb049c9113b8d4287d27d18  /tmp/
RUN ls -l /tmp

# use default install /opt/splunk
RUN yum -y --nogpgcheck localinstall /tmp/Nessus-6.3.7-es6.i386.rpm

# Remove yum metadata.
RUN yum clean all
