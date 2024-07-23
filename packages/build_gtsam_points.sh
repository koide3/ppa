#!/bin/bash
platforms=("amd64" "arm64")
ubuntu_images=("jammy" "noble")
ubuntu_labels=("ubuntu2204" "ubuntu2404")

declare -A pids
declare -A labels

configurations=(
  "ubuntu:noble ubuntu2404 nvidia/cuda:12.5.1-devel-ubuntu24.04 12.5 Dockerfile"
  "ubuntu:jammy ubuntu2204 nvidia/cuda:12.5.1-devel-ubuntu22.04 12.5 Dockerfile"
  "ubuntu:jammy ubuntu2204 nvidia/cuda:12.2.2-devel-ubuntu22.04 12.2 Dockerfile"
  "ubuntu:focal ubuntu2004 nvidia/cuda:12.5.1-devel-ubuntu20.04 12.5 Dockerfile.focal"
  "ubuntu:focal ubuntu2004 nvidia/cuda:12.2.2-devel-ubuntu20.04 12.2 Dockerfile.focal"
)

for platform in "${platforms[@]}"; do
  for configuration in "${configurations[@]}"; do
    config=($configuration)
    ubuntu_image=${config[0]}
    ubuntu_label=${config[1]}
    cuda_base_image=${config[2]}
    cuda_label=${config[3]}
    dockerfile=${config[4]}

    name="gtsam_points:$ubuntu_label.cuda$cuda_label.$platform"
    docker buildx build \
      -t $name \
      -f gtsam_points/docker/deb/${dockerfile} \
      --platform linux/$platform \
      --build-arg="BASE_IMAGE=$ubuntu_image" \
      --build-arg="CUDA_BASE_IMAGE=$cuda_base_image" \
      --build-arg="CUDA_LABEL=$cuda_label" \
      --target extract \
      gtsam_points &
    
    pids[$name]=$!
    labels[$name]=$ubuntu_label
  done
done

for key in "${!pids[@]}"; do
  echo "Waiting for $key pid=${pids[$key]} label=${labels[$key]}"
  wait ${pids[$key]}
done

for key in "${!labels[@]}"; do
  echo "Extracting deb file from $key"
  label=${labels[$key]}
  docker run --rm -v $(realpath $label):/output $key /bin/bash -c "cp /root/deb/*.deb /output/"
done