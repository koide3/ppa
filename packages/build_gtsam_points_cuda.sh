#!/bin/bash
# platforms=("amd64" "arm64")
platform=$1       # amd64
ubuntu_image=$2   # noble
ubuntu_label=$3   # ubuntu2404
nvidia_image=$4   # nvidia/cuda:12.6.3-devel-ubuntu24.04
cuda_label=$5     # 12.6

set -e

name="gtsam_points:$ubuntu_label.cuda$cuda_label.$platform"
docker buildx build \
  -t $name \
  -f docker/Dockerfile.gtsam_points_cuda \
  --platform linux/$platform \
  --build-arg="BASE_IMAGE=ubuntu:$ubuntu_image" \
  --build-arg="CUDA_BASE_IMAGE=$cuda_base_image" \
  --build-arg="CUDA_LABEL=$cuda_label" \
  --target extract \
  gtsam_points

echo "Extracting deb file from $name"
docker run --rm -v $(realpath $ubuntu_label):/output $name /bin/bash -c "cp /root/deb/*.deb /output/ && chmod -R 777 /output/*"