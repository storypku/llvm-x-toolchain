# Copyright 2021 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package(default_visibility = ["//visibility:public"])

# Some targets may need to directly depend on these files.
exports_files(glob([
    "%{prefix}bin/*",
    "%{prefix}lib/*",
    "defs.bzl",
]))

## LLVM toolchain files

filegroup(
    name = "clang",
    srcs = [
        "%{prefix}bin/clang",
        "%{prefix}bin/clang++",
        "%{prefix}bin/clang-cpp",
    ],
)

filegroup(
    name = "ld",
    srcs = [
        "%{prefix}bin/ld.lld",
    ],
)

filegroup(
    name = "include",
    srcs = glob([
        "%{prefix}include/**/c++/**",
        "%{prefix}lib/clang/*/include/**",
    ]),
)

filegroup(
    name = "bin",
    srcs = glob(["%{prefix}bin/**"]),
)

filegroup(
    name = "lib",
    srcs = glob(
        [
            "%{prefix}lib/**/lib*.a",
            "%{prefix}lib/clang/*/lib/**/*.a",
        ],
        exclude = [
            "%{prefix}lib/libLLVM*.a",
            "%{prefix}lib/libclang*.a",
            "%{prefix}lib/liblld*.a",
        ],
    ),
)

filegroup(
    name = "ar",
    srcs = ["%{prefix}bin/llvm-ar"],
)

filegroup(
    name = "as",
    srcs = [
        "%{prefix}bin/clang",
        "%{prefix}bin/llvm-as",
    ],
)

filegroup(
    name = "nm",
    srcs = ["%{prefix}bin/llvm-nm"],
)

filegroup(
    name = "objcopy",
    srcs = ["%{prefix}bin/llvm-objcopy"],
)

filegroup(
    name = "objdump",
    srcs = ["%{prefix}bin/llvm-objdump"],
)

filegroup(
    name = "profdata",
    srcs = ["%{prefix}bin/llvm-profdata"],
)

filegroup(
    name = "dwp",
    srcs = ["%{prefix}bin/llvm-dwp"],
)

filegroup(
    name = "ranlib",
    srcs = ["%{prefix}bin/llvm-ranlib"],
)

filegroup(
    name = "readelf",
    srcs = ["%{prefix}bin/llvm-readelf"],
)

filegroup(
    name = "strip",
    srcs = ["%{prefix}bin/llvm-strip"],
)

filegroup(
    name = "symbolizer",
    srcs = ["%{prefix}bin/llvm-symbolizer"],
)

filegroup(
    name = "clang-tidy",
    srcs = ["%{prefix}bin/clang-tidy"],
)
