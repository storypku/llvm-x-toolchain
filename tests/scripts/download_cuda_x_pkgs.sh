#!/bin/bash
set -euo pipefail

URL_PREFIX="https://repo.download.nvidia.com/jetson/x86_64/bionic/pool/main/"
PKG_DIR="bionic_pkgs"

CUDA_X_PKGS=(
  "c/cuda-thrust/cuda-cccl-cross-aarch64-11-4_11.4.222-1_all.deb"
  "c/cuda-cudart/cuda-driver-cross-aarch64-11-4_11.4.243-1_all.deb"
  "c/cuda-nvcc/cuda-nvcc-cross-aarch64-11-4_11.4.239-1_all.deb"
  "c/cuda-cudart/cuda-cudart-cross-aarch64-11-4_11.4.243-1_all.deb"
  "libc/libcublas/libcublas-cross-aarch64-11-4_11.6.6.23-1_all.deb"
  "c/cuda-nvrtc/cuda-nvrtc-cross-aarch64-11-4_11.4.239-1_all.deb"
  "c/cuda-cupti/cuda-cupti-cross-aarch64-11-4_11.4.239-1_all.deb"
  "c/cuda-nvml-dev/cuda-nvml-cross-aarch64-11-4_11.4.239-1_all.deb"
  "c/cuda-profiler-api/cuda-profiler-api-cross-aarch64-11-4_11.4.239-1_all.deb"
  "libc/libcufft/libcufft-cross-aarch64-11-4_10.6.0.143-1_all.deb"
  "libn/libnpp/libnpp-cross-aarch64-11-4_11.4.0.228-1_all.deb"
  "libc/libcudla/libcudla-cross-aarch64-11-4_11.4.239-1_all.deb"
  "libc/libcurand/libcurand-cross-aarch64-11-4_10.2.5.238-1_all.deb"
  "libc/libcusolver/libcusolver-cross-aarch64-11-4_11.2.0.238-1_all.deb"
  "libc/libcusparse/libcusparse-cross-aarch64-11-4_11.6.0.238-1_all.deb"
  "n/nsight-compute/nsight-compute-addon-l4t-2021.2.5_2021.2.5.2-1_all.deb"
  "c/cuda-nsight-compute-addon-l4t-11-4/cuda-nsight-compute-addon-l4t-11-4_11.4.14-1_all.deb"
  "c/cuda-cross-aarch64/cuda-cross-aarch64_11.4.14-1_all.deb"
  "c/cuda-cross-aarch64-11-4/cuda-cross-aarch64-11-4_11.4.14-1_all.deb"
)

function check_and_download_pkgs() {
  for pkgaddr in "${CUDA_X_PKGS[@]}"; do
    pkg="${pkgaddr##*/}"
    if [[ -f "${PKG_DIR}/${pkg}" ]]; then
      echo >&2 "[OK]: ${pkg} already downloaded"
    else
      echo >&2 "[INFO]: Start to download ${pkg} ..."
      curl -fsSL "${URL_PREFIX}${pkgaddr}" -o "${pkg}"
      echo >&2 "[OK]: ${pkg} successfully downloaded."
    fi
  done
}

# check_and_download_pkgs

function locate_installed_pkgs() {
  for pkgaddr in "${CUDA_X_PKGS[@]}"; do
    pkg="${pkgaddr##*/}"
    pkg="${pkg%%_*}"
    echo >&2 "[INFO]: dpkg -L ${pkg} ..."
    dpkg -L "${pkg}"
  done
}

locate_installed_pkgs
