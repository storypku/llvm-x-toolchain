#!/bin/bash

# Ref: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/jetpack-linux-aarch64-crosscompile-x86
#
# To cross compile Jetson Multimedia API samples
# Inside the container run the commands below:
#   cd /l4t/targetfs/usr/src/jetson_multimedia_api
#   export CROSS_COMPILE=aarch64-linux-gnu-
#   export TARGET_ROOTFS=/l4t/targetfs/
#   make

function x_compil_jetson_multimedia_api() {
  pushd /l4t/targetfs/usr/src/jetson_multimedia_api > /dev/null
  export CROSS_COMPILE=aarch64-linux-gnu-
  export TARGET_ROOTFS=/l4t/targetfs/
  make VERBOSE=1
  popd > /dev/null
}

function x_compil_cuda_samples() {
  pushd /l4t/cuda_samples
  # According to the Ref:
  # ${SOC_SMS} is 72 for Xavier iGPU, 75 for Xavier dGPU, and 87 for Orin iGPU.
  SOC_SMS=87
  make VERBOSE=1 \
    TARGET_ARCH=aarch64 \
    TARGET_OS=linux \
    TARGET_FS=/l4t/targetfs \
    SMS=${SOC_SMS}
  popd > /dev/null
}

function main() {
  if [[ $# -eq 0 ]] || [[ "$1" == "cuda" ]]; then
    x_compil_cuda_samples
  else
    x_compil_jetson_multimedia_api
  fi
}

main "$@"
