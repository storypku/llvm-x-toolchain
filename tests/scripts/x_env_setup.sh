#!/bin/bash
set -euo pipefail
set -x

# To avoid the "Infinite symlink expansion" problem described below 
# for the `local_cuda_cross` repository rule:
# 
# ```
# ERROR: infinite symlink expansion detected
# [start of symlink chain]
# /l4t/targetfs/run/speech-dispatcher
# /l4t/targetfs/run/speech-dispatcher/.cache/speech-dispatcher
# [end of symlink chain]
# ERROR: Infinite symlink expansion, for sysroot_stub/run/speech-dispatcher/.cache/speech-dispatcher, skipping: Infinite symlink expansion
# ERROR: infinite symlink expansion detected
# [start of symlink chain]
# /l4t/targetfs/run/speech-dispatcher
# /l4t/targetfs/run/speech-dispatcher/.speech-dispatcher
# [end of symlink chain]
# ```
# 
# We should run:
# 
# ```
# sudo unlink /l4t/targetfs/usr/bin/X11
# sudo unlink /l4t/targetfs/run/speech-dispatcher/.cache/speech-dispatcher
# sudo unlink /l4t/targetfs/run/speech-dispatcher/.speech-dispatcher
# ```

function extract_targetfs_and_toolchain {
  pushd /l4t > /dev/null
  if [[ ! -d targetfs ]]; then
    tar -I lbzip2 -xf targetfs.tbz2

    unlink /l4t/targetfs/usr/bin/X11
    unlink /l4t/targetfs/run/speech-dispatcher/.cache/speech-dispatcher
    unlink /l4t/targetfs/run/speech-dispatcher/.speech-dispatcher
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
  # 1. python3-pil for compiling Jetson Multimedia API samples
  # 2. libtinfo5 was needed by llvm/clang distribution (e.g., /opt/llvm/bin/clang++)
  apt-get update && apt-get -y -qq install --no-install-recommends \
    file \
    tree \
    curl \
    vim \
    libtinfo5 \
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
