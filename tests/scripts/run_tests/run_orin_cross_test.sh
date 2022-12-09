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
  targets=(
    //examples/cuda:hello_cuda
    //examples/cuda:deviceQuery
    //examples/hello
    //examples/if_platform/...
    //examples/image_net:image_net_demo
  )
  # //examples/base:sha256_test
  # //examples/rules_foreign_cc:example
  # was skipped since libssl-dev missing in Orin targetfs

  expect_success bazel build -s \
    --config=cuda_nvcc \
    --copt="-D__is_signed=___is_signed" \
    --config=orin_cross \
    --@rules_cuda//cuda:cuda_runtime=@local_cuda_x_orin//:cuda_runtime \
    --cuda_gpu_arch=sm_87 \
    "${targets[@]}"

  expect_success bazel build \
    --config=cuda_nvcc \
    --copt="-D__is_signed=___is_signed" \
    --config=orin_cross \
    --@rules_cuda//cuda:cuda_runtime=@local_cuda_x_orin2//:cuda_runtime \
    --cuda_gpu_arch=sm_87 \
    "${targets[@]}"

  expect_success bazel build \
    --config=orin_cross \
    --@rules_cuda//cuda:cuda_runtime=@local_cuda_x_orin//:cuda_runtime \
    --cuda_gpu_arch=sm_80 \
    "${targets[@]}"

  expect_success bazel build \
    --config=orin_cross \
    --@rules_cuda//cuda:cuda_runtime=@local_cuda_x_orin2//:cuda_runtime \
    --cuda_gpu_arch=sm_80 \
    "${targets[@]}"

  # LLVM/Clang < 16.x doesn't support sm_87
  expect_failure bazel build \
    --config=orin_cross \
    --@rules_cuda//cuda:cuda_runtime=@local_cuda_x_orin2//:cuda_runtime \
    --cuda_gpu_arch=sm_87 \
    "${targets[@]}"

  cpu_targets=(
    //examples/hello
    //examples/if_platform/...
    //examples/image_net:image_net_demo
  )

  expect_success bazel build \
    --config=cpu \
    "${cpu_targets[@]}"
}

main "$@"
