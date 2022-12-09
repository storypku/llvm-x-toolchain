#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# Script to find cuda path for cross compilation

import os
import sys


def usage(prog):
    print("Usage: {prog} SYSROOT_DIR TARGET_ARCH".format(prog=prog), file=sys.stderr)


def main(sysroot_dir, target_arch):
    def print_result(inc_dir, lib_dir):
        print("CUDA_X_INC: {}".format(inc_dir))
        print("CUDA_X_LIB: {}".format(lib_dir))

    cuda_path = os.environ.get("CUDA_X_PATH", "/usr/local/cuda")
    if cuda_path.endswith("/"):
        cuda_path = cuda_path[:-1]

    cuda_inc_dir, cuda_lib_dir = locate_sysroot_inc_lib_dirs(
        sysroot_dir, cuda_path, target_arch
    )
    if cuda_inc_dir and cuda_lib_dir:
        print_result(cuda_inc_dir, cuda_lib_dir)
        sys.exit(0)

    cuda_inc_dir, cuda_lib_dir = locate_cuda_cross_inc_lib_dirs(cuda_path, target_arch)
    if cuda_inc_dir and cuda_lib_dir:
        print_result(cuda_inc_dir, cuda_lib_dir)
        sys.exit(0)

    sys.exit(1)


def locate_sysroot_inc_lib_dirs(sysroot_dir, cuda_path, target_arch):
    cuda_inc_dir = "{}{}/include".format(sysroot_dir, cuda_path)
    cuda_lib_dir = "{}{}/lib64".format(sysroot_dir, cuda_path)

    if os.path.exists(cuda_inc_dir) and os.path.exists(cuda_lib_dir):
        return (cuda_inc_dir, cuda_lib_dir)

    return locate_cuda_cross_inc_lib_dirs(
        "{}{}".format(sysroot_dir, cuda_path), target_arch
    )


def locate_cuda_cross_inc_lib_dirs(cuda_path, target_arch):
    targets_dir = "{}/targets/{}-linux".format(cuda_path, target_arch)
    if not os.path.exists(targets_dir):
        return (None, None)

    cuda_inc_dir = "{}/include".format(targets_dir)
    cuda_lib_dir = "{}/lib".format(targets_dir)

    if os.path.exists(cuda_inc_dir) and os.path.exists(cuda_lib_dir):
        # Just pick the first match and return
        return (cuda_inc_dir, cuda_lib_dir)

    return (None, None)


if __name__ == "__main__":
    if len(sys.argv) < 3 or sys.argv[1] in ("-h", "--help"):
        usage(sys.argv[0])
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
