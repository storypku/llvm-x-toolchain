#! /bin/bash
NVCC=/usr/local/cuda/bin/nvcc
CCBIN="${CCBIN:-aarch64-linux-gnu-g++}"

readonly INCS=(
  -Xcompiler -isystem=/l4t/targetfs/usr/include
  -Xcompiler -I/l4t/targetfs/usr/include
  -Xcompiler -isystem=/l4t/targetfs/usr/include/aarch64-linux-gnu
  -Xcompiler -I/l4t/targetfs/usr/include/aarch64-linux-gnu
)

readonly LINKS=(
  -Xlinker -rpath-link=/l4t/targetfs/lib
  -Xlinker -L/l4t/targetfs/lib
  -Xlinker -rpath-link=/l4t/targetfs/lib/aarch64-linux-gnu
  -Xlinker -L/l4t/targetfs/lib/aarch64-linux-gnu
  -Xlinker -rpath-link=/l4t/targetfs/usr/lib
  -Xlinker -L/l4t/targetfs/usr/lib
  -Xlinker -rpath-link=/l4t/targetfs/usr/lib/aarch64-linux-gnu
  -Xlinker -L/l4t/targetfs/usr/lib/aarch64-linux-gnu
)

function build_deviceQuery() {
  local sm="$1"
  gen_codes=(
    -gencode "arch=compute_${sm},code=sm_${sm}"
    -gencode "arch=compute_${sm},code=compute_${sm}"
  )
  my_obj="deviceQuery_${sm}.o"
  my_bin="deviceQuery_${sm}"

  "${NVCC}" \
    -ccbin "${CCBIN}" \
    -m64 \
    "${INCS[@]}" \
    --threads 0 --std=c++11 \
    "${gen_codes[@]}" \
    -o "${my_obj}" \
    -c deviceQuery.cpp

  "${NVCC}" \
    -ccbin "${CCBIN}" \
    -m64 \
    "${INCS[@]}" \
    -Xlinker --sysroot=/l4t/targetfs \
    "${LINKS[@]}" \
    -Xlinker --unresolved-symbols=ignore-in-shared-libs \
    "${gen_codes[@]}" \
    -o "${my_bin}" "${my_obj}"
  rm -f "${my_obj}"
}

function main() {
  if [[ $# -eq 0 ]] || [[ "$1" == "build" ]]; then
    build_deviceQuery 72
    build_deviceQuery 87
  elif [[ "$1" == "clean" ]]; then
    rm -rf ./deviceQuery_72 ./deviceQuery_87
  fi
}

main "$@"

# Interesting enough, running the following command will generate deviceQuery
# binaries that runs on x86_64
# CCBIN=/opt/llvm/bin/clang ./build_devQ.sh "$@"
