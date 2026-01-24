#!/bin/bash
# platforms=("amd64" "arm64")
# ubuntu_images=("focal" "jammy" "noble")
# ubuntu_labels=("ubuntu2004" "ubuntu2204" "ubuntu2404")
platform=$1
ubuntu_image=$2
ubuntu_label=$3

echo "build_iridescence.sh"
echo "platform: $platform"
echo "ubuntu_image: $ubuntu_image"
echo "ubuntu_label: $ubuntu_label"

set -e

name="iridescence:$ubuntu_image.$platform"
docker buildx build --platform linux/$platform -f docker/Dockerfile.iridescence --build-arg="BASE_IMAGE=ubuntu:$ubuntu_image" iridescence -t $name

echo "Extracting deb file from $name"
docker run --rm -v $(realpath $ubuntu_label):/output $name /bin/bash -c "cp /root/iridescence/build/libiridescence*.deb /output/ && chmod 777 /output/*"