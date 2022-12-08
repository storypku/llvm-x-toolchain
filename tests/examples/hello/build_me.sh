#!/bin/bash

# Build may fail with the following error:
#   /opt/llvm/bin/clang++: error while loading shared libraries: libtinfo.so.5:
#   cannot open shared object file: No such file or directory
# To fix, run:
#   sudo apt-get update && sudo apt-get install libtinfo5

CC=/opt/llvm/bin/clang++

"${CC}" --target=aarch64-linux-gnu hello.cc -fuse-ld=lld -stdlib=libstdc++
