#!/bin/bash
# platforms=("amd64" "arm64")
platforms=($1)    # amd64
ubuntu_image=$2   # noble
ubuntu_label=$3   # ubuntu2404

set -e
declare -A pids
declare -A labels

configurations=(
  "ubuntu:$ubuntu_image $ubuntu_label Dockerfile"
)

for platform in "${platforms[@]}"; do
  for configuration in "${configurations[@]}"; do
    config=($configuration)
    ubuntu_image=${config[0]}
    ubuntu_label=${config[1]}
    dockerfile=${config[2]}

    name="gtsam:$ubuntu_label.$platform"
    docker buildx build \
      -t $name \
      -f gtsam/docker/deb/${dockerfile} \
      --platform linux/$platform \
      --build-arg="BASE_IMAGE=$ubuntu_image" \
      --target extract \
      gtsam &

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
