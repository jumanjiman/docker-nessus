#!/bin/bash
set -eEux
set -o pipefail

# Import Tenable's GPG key.
rpm --import tenable-2048.gpg


# Install the package.
rpm -Uvh Nessus-7.0.3-es7.x86_64.rpm
