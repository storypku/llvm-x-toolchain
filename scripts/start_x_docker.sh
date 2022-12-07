#! /bin/bash
set -euo pipefail

# Script to start Jetpack Cross Compilation Docker
# Ref: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/jetpack-linux-aarch64-crosscompile-x86

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# shellcheck disable=SC1090,SC1091
source "${TOP_DIR}/scripts/docker_helper.sh"

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
    bash -c "/workspace/scripts/docker_start_user.sh ${user} ${uid} ${group} ${gid}"
}

function start_jetpack_x_docker() {
  local hostname_dev
  hostname_dev="${JETPACK_X_NAME//_/-}"

  run docker run -itd \
    --privileged \
    --ipc=host \
    --net=host \
    -v /dev/bus/usb:/dev/bus/usb \
    -v "${TOP_DIR}":/workspace \
    --name "${JETPACK_X_NAME}" \
    --workdir=/workspace \
    --hostname="${hostname_dev}" \
    "${JETPACK_X_IMG}"
}

function prepare_git_config() {
  pushd "${TOP_DIR}" > /dev/null
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
  ok "To login, run: "
  ok "  scripts/goto_x_docker.sh"
}

main "$@"
