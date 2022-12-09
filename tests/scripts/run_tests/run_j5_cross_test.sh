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
    //examples/base:sha256_test
    //examples/hello
    //examples/if_platform/...
    //examples/image_net:image_net_demo
    //examples/rules_foreign_cc:example
  )

  expect_success bazel build \
    --config=j5_cross \
    "${targets[@]}"

  j5_imcompatible_targets=(
    //examples/cuda:hello_cuda
    //examples/cuda:deviceQuery
    //examples/if_platform:orin_only
  )

  expect_failure bazel build -k \
    --config=j5_cross \
    "${j5_imcompatible_targets[@]}"
}

main "$@"
