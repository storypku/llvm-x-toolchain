package(default_visibility = ["//visibility:public"])

load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")
load("@rules_cuda//cuda:toolchain.bzl", "cuda_compiler_deps")
load("%{cc_toolchain_config_bzl}", "cc_toolchain_config")

# Following filegroup targets are used when not using absolute paths and shared
# between different toolchains.

# Tools symlinked through this repo. This target is for internal use in the toolchain only.
filegroup(
    name = "internal-use-symlinked-tools",
    srcs = [%{symlinked_tools}
    ],
    visibility = ["//visibility:private"],
)

# Tools wrapped through this repo. This target is for internal use in the toolchain only.
filegroup(
    name = "internal-use-wrapped-tools",
    srcs = [
        "%{wrapper_bin_prefix}cc_wrapper.sh",
    ],
    visibility = ["//visibility:private"],
)

# All internal use files.
filegroup(
    name = "internal-use-files",
    srcs = [
        ":internal-use-symlinked-tools",
        ":internal-use-wrapped-tools",%{extra_compiler_deps}
    ] + cuda_compiler_deps(),
    visibility = ["//visibility:private"],
)

%{cc_toolchains}

# Convenience targets from the LLVM toolchain.
%{convenience_targets}
