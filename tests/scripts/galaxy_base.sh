#!/bin/bash
set -euo pipefail

_BOLD='\033[1m'
_RED='\033[0;31m'
_GREEN='\033[32m'
_WHITE='\033[34m'
_YELLOW='\033[33m'
_NO_COLOR='\033[0m'

function info() {
  (echo >&2 -e "[${_WHITE}${_BOLD}INFO${_NO_COLOR}] $*")
}

function error() {
  (echo >&2 -e "[${_RED}ERROR${_NO_COLOR}] $*")
}

function warning() {
  (echo >&2 -e "${_YELLOW}[WARNING] $*${_NO_COLOR}")
}

function ok() {
  (echo >&2 -e "[${_GREEN}${_BOLD} OK ${_NO_COLOR}] $*")
}

function run() {
  echo >&2 "$*"
  "${@}"
}

