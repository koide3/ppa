#!/bin/bash
platforms=("amd64" "arm64")
ubuntu_images=("focal" "jammy" "noble")
ubuntu_labels=("ubuntu2004" "ubuntu2204" "ubuntu2404")

declare -A pids
declare -A labels

# for ubuntu_image in "${ubuntu_images[@]}"; do
for ((i=0; i<${#ubuntu_images[@]}; i++)); do
  ubuntu_image=${ubuntu_images[$i]}
  ubuntu_label=${ubuntu_labels[$i]}
  for platform in "${platforms[@]}"; do
    name="iridescence:$ubuntu_image.$platform"
    docker buildx build --platform linux/$platform -f iridescence/docker/ubuntu/Dockerfile_deb --build-arg="BASE_IMAGE=ubuntu:$ubuntu_image" iridescence -t $name &
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
  docker run --rm -v $(realpath $label):/output $key /bin/bash -c "cp /root/iridescence/build/libiridescence*.deb /output/"
done
