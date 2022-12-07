load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "orin_only",
    srcs = ["orin_only.cc"],
    target_compatible_with = [
        "//bazel/soctype:orin",
    ],
)
