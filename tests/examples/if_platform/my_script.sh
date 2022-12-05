#! /bin/bash

function main() {
  if [[ $# -eq 0 ]]; then
    echo "Hello world"
  else
    echo "Hello $*"
  fi
}

main "$@"
