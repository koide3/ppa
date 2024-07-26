#!/bin/bash
# docker build -f glim_ros2/docker/deb/Dockerfile.ros2 . -t glim_ros2

mkdir -p local_ppa
cp -R ../ubuntu2004 local_ppa/
cp -R ../ubuntu2204 local_ppa/
cp -R ../ubuntu2404 local_ppa/
cp -R ../setup_ppa.sh local_ppa/

platforms=("amd64")
declare -A pids
declare -A labels

configurations=(
  "ubuntu2004 noetic nvidia/cuda:12.5.1-devel-ubuntu20.04 Dockerfile.ros1"
  # "ubuntu2004 noetic nvidia/cuda:12.5.1-devel-ubuntu20.04 Dockerfile.ros1 -cuda12.2"
  # "ubuntu2004 noetic nvidia/cuda:12.5.1-devel-ubuntu20.04 Dockerfile.ros1 -cuda12.5"
)

for platform in "${platforms[@]}"; do
  for configuration in "${configurations[@]}"; do
    config=($configuration)
    ubuntu_label=${config[0]}
    ros_distro=${config[1]}
    cuda_base_image=${config[2]}
    dockerfile=${config[3]}
    package_suffix=${config[4]}

    name="glim_ros1:$ubuntu_label$package_suffix.$platform"
    echo $name
    docker buildx build \
      -t $name \
      -f glim_ros1/docker/deb/${dockerfile} \
      --platform linux/$platform \
      --build-arg="BASE_IMAGE=$cuda_base_image" \
      --build-arg="ROS_DISTRO=$ros_distro" \
      --build-arg="PACKAGE_SUFFIX=$package_suffix" \
      . &

    pids[$name]=$!
    labels[$name]=$ubuntu_label
  done
done

for key in "${!pids[@]}"; do
  echo "Waiting for $key pid=${pids[$key]} label=${labels[$key]}"
  wait ${pids[$key]} || { echo "job failed" >&2; exit; }
done

for key in "${!labels[@]}"; do
  echo "Extracting deb file from $key"
  label=${labels[$key]}
  docker run --rm -v $(realpath $label):/output $key /bin/bash -c "cp /root/*.deb /output/"
done
