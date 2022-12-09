#!/bin/bash
set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/galaxy_base.sh"

function container_status() {
  docker inspect -f '{{.State.Status}}' "$1" 2> /dev/null
}

function remove_container() {
  local container="$1"
  docker stop "${container}" &> /dev/null
  docker rm -v -f "${container}" &> /dev/null
}

function ensure_one_dev_docker() {
  local container="$1"
  local enforce="$2"
  local status
  if status="$(container_status "${container}")"; then
    if [[ "${status}" == "running" ]]; then
      warning "Another container named ${container} already running."
      if [[ "${enforce}" == false ]]; then
        warning "  Consider starting Dev Docker with the '-f/--force' option. Exiting."
        exit 1
      else
        info "Remove existing container with name [${container}] ..."
      fi
    fi
    remove_container "${container}"
  else
    ok "No previous ${container} found."
  fi
}

function docker_image_exists() {
  local img="$1"
  docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${img}$"
}
