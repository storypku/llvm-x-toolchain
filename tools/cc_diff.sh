#! /bin/bash
set -euo pipefail

CURR_DIR="$(dirname "${BASH_SOURCE[0]}")"

readonly URLS=(
    "https://github.com/bazelbuild/bazel/blob/master/tools/cpp/unix_cc_toolchain_config.bzl"
    "https://github.com/bazelbuild/rules_cc/blob/main/cc/private/toolchain/unix_cc_toolchain_config.bzl"
)

function download_file() {
    echo >&2 "[INFO] Download $1 and save it as $2 ..."
    curl -fsSL "$1" -o "$2"
}

function what_is_different() {
    filename="unix_cc_toolchain_config.bzl"
    local copies=()
    for url in "${URLS[@]}"; do
        proj="${url%%/blob/*}"
        proj_dir="${CURR_DIR}/${proj##*/}.git"
        [[ -d "${proj_dir}" ]] || mkdir -p "${proj_dir}"
        full_path="${proj_dir}/${filename}"
        [[ -f "${full_path}" ]] || rm -f "${full_path}"
        text_url="${url/\/blob\//\/}"
        text_url="${text_url/github.com/raw.githubusercontent.com}"
        download_file "${text_url}" "${full_path}"
        copies+=("${full_path}")
    done
    diff -aruN "${copies[@]}"
}

function cleanup() {
    rm -rf "${CURR_DIR}"/*.git
}

function main() {
    if [[ $# -gt 0 && "$1" == "clean" ]]; then
        cleanup
    else
        what_is_different
    fi
}

main "$@"


