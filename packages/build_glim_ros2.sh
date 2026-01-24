#!/bin/bash
# docker build -f glim_ros2/docker/deb/Dockerfile.ros2 . -t glim_ros2

platform=$1       # amd64
ubuntu_label=$2   # ubuntu2404
ros_distro=$3     # jazzy
nvidia_image=$4   # nvidia/cuda:12.6.3-devel-ubuntu24.04
cuda_label=$5     # 12.6

set -e

# cuda_label is empty set package_suffix to empty
if [ -n "$cuda_label" ]; then
  package_suffix="-cuda$cuda_label"
else
  package_suffix=""
fi

name="glim_ros2:$ubuntu_label$package_suffix.$platform"
echo $name
docker buildx build \
  -t $name \
  -f docker/Dockerfile.glim_ros2 \
  --platform linux/$platform \
  --build-arg="BASE_IMAGE=$nvidia_image" \
  --build-arg="ROS_DISTRO=$ros_distro" \
  --build-arg="PACKAGE_SUFFIX=$package_suffix" \
  .

echo "Extracting deb file from $name"
docker run --rm -v $(realpath $ubuntu_label):/output $name /bin/bash -c "cp /root/*.deb /output/ && chmod -R 777 /output/*"
