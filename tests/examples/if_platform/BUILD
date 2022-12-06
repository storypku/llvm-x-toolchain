load("@rules_cc//cc:defs.bzl", "cc_binary")
load("//bazel:common.bzl", "if_j5")

package(default_visibility = ["//visibility:public"])

# bazel run :my_script --platforms=//:j5_cross_platform
sh_binary(
    name = "my_script",
    srcs = ["my_script.sh"],
    args = if_j5(["j5"]),
)

# TODO(storypku):
# Illegal ambiguous match on configurable attribute "copts"
# 1) //bazel:cpu_only v.s. //bazel:linux_j5
# 2) //bazel:linux_aarch64_cpu_only v.s. //bazel:linux_j5
# Multiple matches are not allowed unless one is unambiguously more specialized.

cc_binary(
    name = "my_id",
    srcs = ["my_id.cc"],
    copts = select({
        "//bazel:linux_j5": [
            "-DQ_PLATFORM=\\\"J5\\\"",
            "-DQ_CPU_ONLY_EXT=1",
        ],
        "//bazel:linux_x86_64_cpu_only": [
            "-DQ_PLATFORM=\\\"AMD64\\\"",
            "-DQ_CPU_ONLY_EXT=4",
        ],
        "//bazel:linux_x86_64_cuda": [
            "-DQ_PLATFORM=\\\"AMD64\\\"",
        ],
        "//bazel:linux_xavier_cpu_only": [
            "-DQ_PLATFORM=\\\"XAVIER\\\"",
            "-DQ_CPU_ONLY_EXT=2",
        ],
        "//bazel:linux_xavier_cuda": [
            "-DQ_PLATFORM=\\\"XAVIER\\\"",
        ],
        "//conditions:default": [],
    }),
)
