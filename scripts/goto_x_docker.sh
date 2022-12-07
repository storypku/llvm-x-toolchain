#! /bin/bash
set -u

USER="${USER:-whoami}"

JETPACK_X_CONTAINER="jetpack_x_${USER}"
xhost +local:"${USER}" &> /dev/null

docker exec \
  -u "${USER}" \
  -it "${JETPACK_X_CONTAINER}" \
  /bin/bash

xhost -local:"${USER}" 1> /dev/null 2>&1
