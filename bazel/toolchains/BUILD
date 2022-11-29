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

load(":toolchain_config.bzl", "define_my_toolchains")

# Register the toolchain with Bazel. Most of these attribute just tell Bazel
# where to find the files needed to run C++ commands. The toolchain_config
# attribute registers the behavior specification declared above.
# cc_toolchain(

filegroup(
    name = "toolchain_files",
    srcs = [
        "bin/sample_compiler",
        "bin/sample_linker",
    ],
)

define_my_toolchains()
