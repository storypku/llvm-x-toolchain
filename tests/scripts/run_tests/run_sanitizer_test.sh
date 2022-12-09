#! /bin/bash
set -euo pipefail

# shellcheck disable=SC1090,SC1091
. "$(dirname "${BASH_SOURCE[0]}")/test_base.sh"

ARCH="$(uname -m)"

function main() {
  targets=(
    //examples/asan:use_after_free
  )

  if [[ "${ARCH}" == "x86_64" ]]; then
    my_toolchain="@llvm_toolchain_for_asan//:cc-toolchain-x86_64-linux"
  else
    my_toolchain="@llvm_toolchain_for_asan//:cc-toolchain-aarch64-linux"
  fi

  expect_success bazel build \
    --config=asan \
    --extra_toolchains="${my_toolchain}" \
    "${targets[@]}"

  expect_failure bazel run \
    --config=asan \
    --extra_toolchains="${my_toolchain}" \
    "${targets[@]}"
}

main "$@"
