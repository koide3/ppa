#!/bin/bash

# exit if not root
if [ "$EUID" -ne 0 ]; then
  echo "Must be run with sudo"
  exit 1
fi

# Extract release from /etc/os-release
. /etc/os-release
release="${UBUNTU_CODENAME}"
echo release=$release

if [ $release == "noble" ]; then
  ubuntu_label="ubuntu2404"
elif [ $release == "jammy" ]; then
  ubuntu_label="ubuntu2204"
elif [ $release == "focal" ]; then
  ubuntu_label="ubuntu2004"
else
  echo "Unsupported release: $release"
  exit 1
fi

# Add PPA to sources.list.d/koide3_ppa.list
echo "ubuntu_label=$ubuntu_label"
echo 'echo "deb [trusted=yes] file:///ppa/$ubuntu_label ./" | tee /etc/apt/sources.list.d/koide3_ppa.list'

echo "deb [trusted=yes] file:///ppa/$ubuntu_label ./" | tee /etc/apt/sources.list.d/koide3_ppa.list
