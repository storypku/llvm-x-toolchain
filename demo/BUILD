load("@rules_cc//cc:defs.bzl", "cc_library")
load("//bazel:common.bzl", "if_j5")

package(default_visibility = ["//visibility:public"])

# The library we want to build. Building this calls two C++ actions: compile (.cc ->
# .o) and archive (.o -> .a).
cc_library(
    name = "buildme",
    srcs = ["buildme.cc"],
)

sh_binary(
    name = "my_script",
    srcs = ["my_script.sh"],
    args = if_j5(["j5"]),
)

# This target only build for "bazel build :j5_only --platforms=//bazel/platforms:j5_cross"
cc_library(
    name = "j5_only",
    srcs = ["j5_only.cc"],
    target_compatible_with = [
        "//bazel/soctype:j5",
    ],
)

cc_library(
    name = "xavier_only",
    srcs = ["xavier_only.cc"],
    target_compatible_with = [
        "//bazel/soctype:xavier",
    ],
)
