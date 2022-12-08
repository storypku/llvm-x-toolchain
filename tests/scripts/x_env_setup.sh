#!/bin/bash
set -euo pipefail
set -x

function extract_targetfs_and_toolchain {
  pushd /l4t > /dev/null
  if [[ ! -d targetfs ]]; then
    tar -I lbzip2 -xf targetfs.tbz2
  fi
  mkdir toolchain
  tar -C toolchain -xf toolchain.tar.gz
  popd > /dev/null
}

function install_cuda_samples() {
  pushd /l4t > /dev/null
  /l4t/targetfs/usr/local/cuda/bin/cuda-install-samples-11.4.sh .
  mv ./NVIDIA_CUDA-11.4_Samples cuda_samples
  popd > /dev/null
}

function change_srcdir_owner() {
  local user="$1"
  local group
  group="$(id -n -g "${user}")"
  chown -R "${user}:${group}" \
    /l4t/targetfs/usr/src \
    /l4t/cuda_samples \
    /l4t/toolchain
}

function install_dev_tools() {
  # python3-pil for compiling Jetson Multimedia API samples
  apt-get update && apt-get -y -qq install --no-install-recommends \
    file \
    tree \
    curl \
    vim \
    python3-pil
}

function main() {
  local user="$1"
  extract_targetfs_and_toolchain
  install_cuda_samples
  change_srcdir_owner "${user}"
  install_dev_tools
}

main "$@"
set +x
