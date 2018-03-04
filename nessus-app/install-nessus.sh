#!/bin/bash
set -eEux
set -o pipefail

# Import Tenable's GPG key.
rpm --import https://static.tenable.com/marketing/RPM-GPG-KEY-Tenable

readonly NESSUS_VERSION="${NESSUS_VERSION:-7.0.2}"
readonly RPM_NAME="Nessus-${NESSUS_VERSION}-es7.x86_64.rpm"
readonly BASE_URL="https://tenable-downloads-production.s3.amazonaws.com/uploads/download/file"

# Find the ID.
DOWNLOAD_ID="$(
  curl -ssl -o - "https://www.tenable.com/downloads/nessus" |
  sed -n -e "s/.*data-download-id=\"\\([0-9]*\\)\".*data-file-name=\"${RPM_NAME}\".*/\\1/p"
)"
readonly DOWNLOAD_ID

# Install the package.
rpm -Uvh "${BASE_URL}/${DOWNLOAD_ID}/${RPM_NAME}"
