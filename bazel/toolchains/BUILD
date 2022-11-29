# Proof-of-concept example showing how to write a custom C++ toolchain.
#
# Important documentation:
#
# - https://docs.bazel.build/versions/master/platforms-intro.html#c
# - https://docs.bazel.build/versions/master/tutorial/cc-toolchain-config.html
# - https://docs.bazel.build/versions/master/be/c-cpp.html#cc_toolchain
#
# There are two ways to select C++ toolchains:
#
#  - NEW (USE IF POSSIBLE): with the --platforms flag
#  - LEGACY: with the --crosstool_top and --cpu flags
#
# See https://docs.bazel.build/versions/master/platforms-intro.html#c for details.
#
# This example demonstrates both approaches.

load("@rules_cc//cc:defs.bzl", "cc_toolchain")

# Load the Starlark logic defining the toolchain's behavior. For example: what
# program runs to compile a source file and how its command line is
# constructed. See toolchain_config.bzl for details.
load(":toolchain_config.bzl", "cc_toolchain_config")

# This example intentionally makes the cc_toolchain_config definition
# simple. You could alternative add attributes to support multiple
# cc_toolchain_config targets with finer customization.
cc_toolchain_config(
    name = "x86_64_toolchain_config",
    host_arch = "x86_64",
    target_arch = "x86_64",
)

cc_toolchain_config(
    name = "x86_64_asan_toolchain_config",
    flavor = "asan",
    host_arch = "x86_64",
    target_arch = "x86_64",
)

# Register the toolchain with Bazel. Most of these attribute just tell Bazel
# where to find the files needed to run C++ commands. The toolchain_config
# attribute registers the behavior specification declared above.
cc_toolchain(
    name = "x86_64_cc_toolchain",
    all_files = ":toolchain_files",
    ar_files = ":toolchain_files",
    compiler_files = ":toolchain_files",
    dwp_files = ":toolchain_files",
    linker_files = ":toolchain_files",
    objcopy_files = ":toolchain_files",
    strip_files = ":toolchain_files",
    toolchain_config = ":x86_64_toolchain_config",
)

cc_toolchain(
    name = "x86_64_asan_cc_toolchain",
    all_files = ":toolchain_files",
    ar_files = ":toolchain_files",
    compiler_files = ":toolchain_files",
    dwp_files = ":toolchain_files",
    linker_files = ":toolchain_files",
    objcopy_files = ":toolchain_files",
    strip_files = ":toolchain_files",
    toolchain_config = ":x86_64_asan_toolchain_config",
)

filegroup(
    name = "toolchain_files",
    srcs = [
        "bin/sample_compiler",
        "bin/sample_linker",
    ],
)

# Implements legacy toolchain selection.
#
# Setting --crosstool_top here registers the set of available
# toolchains. Setting --cpu to one of the toolchain attribute's keys selects a
#  toolchain.
# cc_toolchain_suite(
#    name = "legacy_selector",
#    toolchains = {
#        "x86": ":x86_64_cc_toolchain",
#    },
# )

# Implements platform-based (recommended) toolchain selection.
#
# See https://docs.bazel.build/versions/master/platforms-intro.html. The main
# differences are:
#
#  1. --cpu / --crosstool_top are replaced by a platform() definition with
#       much more customizable properties. For example, a platform can specify
#       OS, device type (server, phone, tablet) or custom hardware extensions.
#  2. All languages can support platform-based toolchains. A single --platforms
#       value can choose C++, Python, Scala, and all other toolchains in your
#       build. This is especially useful for multi-language builds.
#  3. Platforms  support features like incompatible target skipping:
#       https://docs.bazel.build/versions/master/platforms.html#skipping-incompatible-targets.
toolchain(
    name = "x86_64_toolchain",
    # Trigger this toolchain for x86-compatible platforms.
    # See https://github.com/bazelbuild/platforms.
    target_compatible_with = ["@platforms//cpu:x86_64"],
    # Register this toolchain with platforms.
    toolchain = ":x86_64_cc_toolchain",
    # The public interface for all C++ toolchains. Starlark rules that use C++
    # access the toolchain through this interface.
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "x86_64_asan_toolchain",
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "//bazel/flavor:asan",
    ],
    toolchain = ":x86_64_asan_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

# ===== Native AArch64 Toolchain(s) =====
cc_toolchain_config(
    name = "xavier_toolchain_config",
    host_arch = "aarch64",
    target_arch = "aarch64",
)

cc_toolchain(
    name = "xavier_cc_toolchain",
    all_files = ":toolchain_files",
    ar_files = ":toolchain_files",
    compiler_files = ":toolchain_files",
    dwp_files = ":toolchain_files",
    linker_files = ":toolchain_files",
    objcopy_files = ":toolchain_files",
    strip_files = ":toolchain_files",
    toolchain_config = ":xavier_toolchain_config",
)

toolchain(
    name = "xavier_toolchain",
    exec_compatible_with = [
        "@platforms//cpu:aarch64",
    ],
    target_compatible_with = [
        "@platforms//cpu:aarch64",
        "//bazel/soctype:xavier",
    ],
    toolchain = ":aarch64_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain_config(
    name = "aarch64_toolchain_config",
    host_arch = "aarch64",
    target_arch = "aarch64",
)

cc_toolchain(
    name = "aarch64_cc_toolchain",
    all_files = ":toolchain_files",
    ar_files = ":toolchain_files",
    compiler_files = ":toolchain_files",
    dwp_files = ":toolchain_files",
    linker_files = ":toolchain_files",
    objcopy_files = ":toolchain_files",
    strip_files = ":toolchain_files",
    toolchain_config = ":aarch64_toolchain_config",
)

toolchain(
    name = "aarch64_toolchain",
    target_compatible_with = ["@platforms//cpu:aarch64"],
    toolchain = ":aarch64_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

# ===== Cross Compiled AArch64 Toolchains =====

cc_toolchain_config(
    name = "j5_cross_toolchain_config",
    host_arch = "x86_64",
    soctype = "j5",
    target_arch = "aarch64",
)

cc_toolchain(
    name = "j5_cross_cc_toolchain",
    all_files = ":toolchain_files",
    ar_files = ":toolchain_files",
    compiler_files = ":toolchain_files",
    dwp_files = ":toolchain_files",
    linker_files = ":toolchain_files",
    objcopy_files = ":toolchain_files",
    strip_files = ":toolchain_files",
    toolchain_config = ":j5_cross_toolchain_config",
)

toolchain(
    name = "j5_cross_toolchain",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "//bazel/soctype:j5",
        "@platforms//cpu:aarch64",
    ],
    toolchain = ":j5_cross_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

# X9HP
cc_toolchain_config(
    name = "xavier_cross_toolchain_config",
    host_arch = "x86_64",
    soctype = "xavier",
    target_arch = "aarch64",
)

cc_toolchain(
    name = "xavier_cross_cc_toolchain",
    all_files = ":toolchain_files",
    ar_files = ":toolchain_files",
    compiler_files = ":toolchain_files",
    dwp_files = ":toolchain_files",
    linker_files = ":toolchain_files",
    objcopy_files = ":toolchain_files",
    strip_files = ":toolchain_files",
    toolchain_config = ":xavier_cross_toolchain_config",
)

toolchain(
    name = "xavier_cross_toolchain",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "//bazel/soctype:xavier",
        "@platforms//cpu:aarch64",
    ],
    toolchain = ":xavier_cross_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
