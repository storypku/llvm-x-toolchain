package(default_visibility = ["//visibility:public"])

# Define a platform matching any x86-compatible toolchain. See
# https://docs.bazel.build/versions/master/platforms.html.
platform(
    name = "x86_64",
    constraint_values = ["@platforms//cpu:x86_64"],
)

platform(
    name = "x86_64_asan",
    constraint_values = [
        "//bazel/flavor:asan",
    ],
    parents = [":x86_64"],
)

platform(
    name = "aarch64",
    constraint_values = ["@platforms//cpu:aarch64"],
)

# Native Platform for Xavier
platform(
    name = "xavier",
    constraint_values = [
        "//bazel/soctype:xavier",
    ],
    parents = [":aarch64"],
)

# Cross Compilation Platform for Xavier and J5
platform(
    name = "xavier_cross",
    constraint_values = [
        "//bazel/soctype:xavier",
    ],
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
    ],
    parents = [":aarch64"],
)

platform(
    name = "j5_cross",
    constraint_values = [
        "//bazel/soctype:j5",
    ],
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
    ],
    parents = [":aarch64"],
)
