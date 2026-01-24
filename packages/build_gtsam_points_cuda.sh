#!/bin/bash
# platforms=("amd64" "arm64")
platforms=($1)    # amd64
ubuntu_image=$2   # noble
ubuntu_label=$3   # ubuntu2404
nvidia_image=$4   # nvidia/cuda:12.6.3-devel-ubuntu24.04
cuda_label=$5     # 12.6

set -e
declare -A pids
declare -A labels

configurations=(
  "ubuntu:$ubuntu_image $ubuntu_label $nvidia_image $cuda_label"
)

for platform in "${platforms[@]}"; do
  for configuration in "${configurations[@]}"; do
    config=($configuration)
    ubuntu_image=${config[0]}
    ubuntu_label=${config[1]}
    cuda_base_image=${config[2]}
    cuda_label=${config[3]}

    name="gtsam_points:$ubuntu_label.cuda$cuda_label.$platform"
    docker buildx build \
      -t $name \
      -f docker/Dockerfile.gtsam_points_cuda \
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
  wait ${pids[$key]} || { echo "job failed" >&2; exit; }
done

for key in "${!labels[@]}"; do
  echo "Extracting deb file from $key"
  label=${labels[$key]}
  docker run --rm -v $(realpath $label):/output $key /bin/bash -c "cp /root/deb/*.deb /output/ && chmod -R 777 /output/*"
done
