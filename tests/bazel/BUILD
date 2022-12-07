package(default_visibility = ["//visibility:public"])

exports_files([
    "*.bzl",
])

config_setting(
    name = "cpu_only",
    flag_values = {"@rules_cuda//cuda:enable_cuda": "False"},
)

config_setting(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
)

config_setting(
    name = "linux_aarch64",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

config_setting(
    name = "linux_x86_64_cpu_only",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "False"},
)

config_setting(
    name = "linux_x86_64_cuda",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "True"},
)

config_setting(
    name = "linux_aarch64_cpu_only",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "False"},
)

config_setting(
    name = "linux_aarch64_cuda",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "True"},
)

config_setting(
    name = "linux_j5",
    constraint_values = [
        "//bazel/soctype:j5",
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "False"},
)

config_setting(
    name = "linux_orin",
    constraint_values = [
        "//bazel/soctype:orin",
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

config_setting(
    name = "linux_orin_cpu_only",
    constraint_values = [
        "//bazel/soctype:orin",
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "False"},
)

config_setting(
    name = "linux_orin_cuda",
    constraint_values = [
        "//bazel/soctype:orin",
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    flag_values = {"@rules_cuda//cuda:enable_cuda": "True"},
)
