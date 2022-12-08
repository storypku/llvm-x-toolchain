#! /bin/bash
set -euo pipefail

# Script to start Jetpack Cross Compilation Docker
# Ref: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/jetpack-linux-aarch64-crosscompile-x86

PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
CHILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

PARENT_DIR_IN="/workspace"
CHILD_DIR_IN="${PARENT_DIR_IN}/tests"
TARGET_FS="/l4t/targetfs"

# shellcheck disable=SC1090,SC1091
source "${CHILD_DIR}/scripts/docker_helper.sh"

DOCKER_USER="${USER:-whoami}"
JETPACK_X_NAME="jetpack_x_${DOCKER_USER}"

JETPACK_X_IMG="nvcr.io/nvidia/jetpack-linux-aarch64-crosscompile-x86:5.0.2"
ENFORCE=false

function usage() {
  cat << EOF
Usage: $0 [options] ...
OPTIONS:
    -f, --force             Force removal of conflicting running container(s)
    -h, --help              Show this message and exit
EOF
}

function parse_cmdline_args() {
  while [[ $# -gt 0 ]]; do
    local opt="$1"
    shift
    case "${opt}" in
      -f | --force)
        ENFORCE=true
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  done
}

function docker_start_user() {
  local container="$1"
  local user="$2"

  local uid group gid
  uid="$(id -u)"
  group="$(id -g -n)"
  gid="$(id -g)"

  docker exec -u root "${container}" \
    bash -c "${CHILD_DIR_IN}/scripts/docker_start_user.sh ${user} ${uid} ${group} ${gid}"
}

function jetpack_x_env_setup() {
  local container="$1"
  local user="$2"
  docker exec -u root "${container}" \
    bash -c "${CHILD_DIR_IN}/scripts/x_env_setup.sh ${user}"
}

function start_jetpack_x_docker() {
  local hostname_in
  hostname_in="${JETPACK_X_NAME//_/-}"

  readonly llvm_dir="/opt/llvm"
  declare -a mounts
  mounts+=(
    "-v" "${PARENT_DIR}:${PARENT_DIR_IN}"
    "-v" "/dev/bus/usb:/dev/bus/usb"
  )
  if [[ -d "${TARGET_FS}" ]]; then
    mounts+=("-v" "${TARGET_FS}:${TARGET_FS}")
  fi
  if [[ -x "${llvm_dir}/bin/clang" ]]; then
    mounts+=("-v" "${llvm_dir}:${llvm_dir}")
  fi

  run docker run -itd \
    --privileged \
    --ipc=host \
    --net=host \
    "${mounts[@]}" \
    --add-host "${hostname_in}:127.0.0.1" \
    --hostname="${hostname_in}" \
    --workdir="${CHILD_DIR_IN}" \
    --name "${JETPACK_X_NAME}" \
    "${JETPACK_X_IMG}"
}

function prepare_git_config() {
  pushd "${PARENT_DIR}" > /dev/null
  git config --local include.path "../.gitconfig"
  popd > /dev/null
}

function main() {
  parse_cmdline_args "$@"
  ensure_one_dev_docker "${JETPACK_X_NAME}" "${ENFORCE}"

  prepare_git_config

  start_jetpack_x_docker
  ok "Successfully started ${JETPACK_X_NAME} based on ${JETPACK_X_IMG}"
  info "Setup user account and grant permissions for ${DOCKER_USER} ..."
  docker_start_user "${JETPACK_X_NAME}" "${DOCKER_USER}"
  jetpack_x_env_setup "${JETPACK_X_NAME}" "${DOCKER_USER}"
  ok "To login, run: "
  ok "  scripts/goto_x_docker.sh"
}

main "$@"
