#!/bin/bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# shellcheck disable=SC1090,SC1091
. "${SCRIPTS_DIR}/galaxy_base.sh"

function expect_success() {
  if $@; then
    ok "Success as expected: $*"
  else
    error "Failed unexpectedly: $*"
  fi
}

function expect_failure() {
  if ! "$@"; then
    ok "Failed as expected: $*"
  else
    error "Success unexpectedly: $*"
  fi
}

