#! /bin/bash
set -euo pipefail

NVCC=/usr/local/cuda/bin/nvcc
CCBIN="${CCBIN:-aarch64-linux-gnu-g++}"

X_PKG_EXIST="${X_PKG_EXIST:-0}"

readonly COMMON_INCS=(
  -Xcompiler -isystem=/l4t/targetfs/usr/include
  -Xcompiler -I/l4t/targetfs/usr/include
  -Xcompiler -isystem=/l4t/targetfs/usr/include/aarch64-linux-gnu
  -Xcompiler -I/l4t/targetfs/usr/include/aarch64-linux-gnu
)

readonly TARGETFS_CUDA_INCS=(
  -Xcompiler -isystem=/l4t/targetfs/usr/local/cuda-11.4/include
  -Xcompiler -I/l4t/targetfs/usr/local/cuda-11.4/include
)

readonly X_PKG_CUDA_INCS=(
  -Xcompiler -isystem=/usr/local/cuda-11.4/targets/aarch64-linux/include
  -Xcompiler -I/usr/local/cuda-11.4/targets/aarch64-linux/include
)

readonly COMMON_LINKS=(
  -Xlinker -rpath-link=/l4t/targetfs/lib
  -Xlinker -L/l4t/targetfs/lib
  -Xlinker -rpath-link=/l4t/targetfs/lib/aarch64-linux-gnu
  -Xlinker -L/l4t/targetfs/lib/aarch64-linux-gnu
  -Xlinker -rpath-link=/l4t/targetfs/usr/lib
  -Xlinker -L/l4t/targetfs/usr/lib
  -Xlinker -rpath-link=/l4t/targetfs/usr/lib/aarch64-linux-gnu
  -Xlinker -L/l4t/targetfs/usr/lib/aarch64-linux-gnu
)

readonly TARGETFS_CUDA_LINKS=(
  -Xlinker -rpath-link=/l4t/targetfs/usr/local/cuda-11.4/lib64
  -Xlinker -L/l4t/targetfs/usr/local/cuda-11.4/lib64
)

readonly X_PKG_CUDA_LINKS=(
  -Xlinker -rpath-link=/usr/local/cuda-11.4/targets/aarch64-linux/lib
  -Xlinker -L/usr/local/cuda-11.4/targets/aarch64-linux/lib
)

function build_deviceQuery() {
  local sm="$1"

  gen_codes=(
    -gencode "arch=compute_${sm},code=sm_${sm}"
    -gencode "arch=compute_${sm},code=compute_${sm}"
  )
  my_obj="deviceQuery_${sm}.o"
  my_bin="deviceQuery_${sm}"

  declare -a includes links
  includes+=("${COMMON_INCS[@]}")
  links+=("${COMMON_LINKS[@]}")

  if [[ "${X_PKG_EXIST}" -eq 0 ]]; then
    includes+=("${TARGETFS_CUDA_INCS[@]}")
    links+=("${TARGETFS_CUDA_LINKS[@]}")
  else
    includes+=("${X_PKG_CUDA_INCS[@]}")
    links+=("${X_PKG_CUDA_LINKS[@]}")
  fi

  "${NVCC}" \
    -ccbin "${CCBIN}" \
    -m64 \
    "${includes[@]}" \
    --threads 0 --std=c++11 \
    "${gen_codes[@]}" \
    -o "${my_obj}" \
    -c deviceQuery.cpp

  "${NVCC}" \
    -ccbin "${CCBIN}" \
    -m64 \
    "${includes[@]}" \
    -Xlinker --sysroot=/l4t/targetfs \
    "${links[@]}" \
    -Xlinker --unresolved-symbols=ignore-in-shared-libs \
    "${gen_codes[@]}" \
    -o "${my_bin}" "${my_obj}"
  rm -f "${my_obj}"
}

function main() {
  readonly sms=("72" "75" "87")
  if [[ $# -eq 0 ]] || [[ "$1" == "build" ]]; then
    for sm in "${sms[@]}"; do
      build_deviceQuery "${sm}"
    done
  elif [[ "$1" == "clean" ]]; then
    for sm in "${sms[@]}"; do
      rm -f ./"deviceQuery_${sm}" || true
    done
  fi
}

main "$@"

# Interesting enough, running the following command will generate deviceQuery
# binaries that runs on x86_64
# CCBIN=/opt/llvm/bin/clang ./build_devQ.sh "$@"
