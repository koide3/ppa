#!/bin/bash
# platforms=("amd64" "arm64")
platform=$1    # amd64
ubuntu_image=$2   # noble
ubuntu_label=$3   # ubuntu2404

echo "build_gtsam.sh"
echo "platform: $platform"
echo "ubuntu_image: $ubuntu_image"
echo "ubuntu_label: $ubuntu_label"

set -e

name="gtsam:$ubuntu_label.$platform"
docker buildx build \
  -t $name \
  -f docker/Dockerfile.gtsam \
  --platform linux/$platform \
  --build-arg="BASE_IMAGE=ubuntu:$ubuntu_image" \
  --target extract \
  gtsam


echo "Extracting deb file from $name"
docker run --rm -v $(realpath $ubuntu_label):/output $name /bin/bash -c "cp /root/deb/*.deb /output/ && chmod -R 777 /output/*"