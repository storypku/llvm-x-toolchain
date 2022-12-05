load("//bazel:common.bzl", "if_j5")

package(default_visibility = ["//visibility:public"])

# bazel run :my_script --platforms=//:j5_cross_platform
sh_binary(
    name = "my_script",
    srcs = ["my_script.sh"],
    args = if_j5(["j5"]),
)


