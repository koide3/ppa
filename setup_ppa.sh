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
echo 'curl -s --compressed "https://koide3.github.io/ppa/$ubuntu_label/KEY.gpg" | gpg --dearmor | tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null'
echo 'echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/$ubuntu_label ./" | tee /etc/apt/sources.list.d/koide3_ppa.list'

curl -s --compressed "https://koide3.github.io/ppa/$ubuntu_label/KEY.gpg" | gpg --dearmor | tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/$ubuntu_label ./" | tee /etc/apt/sources.list.d/koide3_ppa.list
