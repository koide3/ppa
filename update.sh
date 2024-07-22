#!/bin/bash

distros=("ubuntu2004" "ubuntu2204" "ubuntu2404")

for distro in "${distros[@]}"; do
  echo "Updating $distro"
  pushd .

  cd $distro
  dpkg-scanpackages --multiversion . > Packages
  gzip -k -f Packages

  apt-ftparchive release . > Release
  gpg --default-key "k.koide@aist.go.jp" -abs -o - Release > Release.gpg
  gpg --default-key "k.koide@aist.go.jp" --clearsign -o - Release > InRelease

  ls

  popd
done
