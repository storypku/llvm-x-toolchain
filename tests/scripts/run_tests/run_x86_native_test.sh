#! /bin/bash
set -euo pipefail

# shellcheck disable=SC1090,SC1091
. "$(dirname "${BASH_SOURCE[0]}")/test_base.sh"

ARCH="$(uname -m)"

if [[ "${ARCH}" != "x86_64" ]]; then
  warning "Please run this script on an x86_64 system."
  exit 1
fi

function main() {
  cpu_targets=(
    //examples/base:sha256_test
    //examples/hello
    //examples/if_platform/...
    //examples/image_net:image_net_demo
    //examples/omp_test
    //examples/rules_foreign_cc:example
  )

  gpu_targets=(
    //examples/cuda:hello_cuda
    //examples/cuda:deviceQuery
  )

  expect_success bazel build \
    --cuda_gpu_arch=sm_70,sm_75,sm_80,sm_86 \
    "${cpu_targets[@]}" \
    "${gpu_targets[@]}"

  expect_success bazel build \
    --config=cuda_nvcc \
    --copt="-D__is_signed=___is_signed" \
    --cuda_gpu_arch=sm_70,sm_75,sm_80,sm_86 \
    "${cpu_targets[@]}" \
    "${gpu_targets[@]}"


  expect_success bazel build \
    --config=cpu \
    "${cpu_targets[@]}"
    
  imcompatible_targets=(
    //examples/if_platform:orin_only
  )
  incompatible_targets+=("${gpu_targets[@]}")

  expect_failure bazel build -k \
    "${imcompatible_targets[@]}"
}

main "$@"
