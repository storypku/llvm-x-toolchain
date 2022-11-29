"""Sample Starlark definition defining a C++ toolchain's behavior.

When you build a cc_* rule, this logic defines what programs run for what
build steps (e.g. compile / link / archive) and how their command lines are
structured.

This is a proof-of-concept simple implementation. It doesn't construct fancy
command lines and uses mock shell scripts to compile and link
("sample_compiler" and "sample_linker"). See
https://docs.bazel.build/versions/main/cc-toolchain-config-reference.html and
https://docs.bazel.build/versions/main/tutorial/cc-toolchain-config.html for
advanced usage.
"""

load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "tool_path")

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "ar",
            path = "bin/sample_linker",
        ),
        tool_path(
            name = "cpp",
            path = "not_used_in_this_example",
        ),
        tool_path(
            name = "gcc",
            path = "bin/sample_compiler",
        ),
        tool_path(
            name = "gcov",
            path = "not_used_in_this_example",
        ),
        tool_path(
            name = "ld",
            path = "sample_linker",
        ),
        tool_path(
            name = "nm",
            path = "not_used_in_this_example",
        ),
        tool_path(
            name = "objdump",
            path = "not_used_in_this_example",
        ),
        tool_path(
            name = "strip",
            path = "not_used_in_this_example",
        ),
    ]
    host_system_name = ctx.attr.host_arch
    target_system_name = ctx.attr.target_arch
    print("Host: {}, Target: {}".format(host_system_name, target_system_name))
    print("Flavor: {}".format(ctx.attr.flavor))
    soctype = ctx.attr.soctype
    print("SocType: {}".format(soctype))
    if ctx.attr.host_arch != ctx.attr.target_arch:
        print("X-Compilation for {}".format(soctype))

    # Documented at
    # https://docs.bazel.build/versions/main/skylark/lib/cc_common.html#create_cc_toolchain_config_info.
    #
    # create_cc_toolchain_config_info is the public interface for registering
    # C++ toolchain behavior.
    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "custom-toolchain-identifier",
        host_system_name = host_system_name,
        target_system_name = target_system_name,
        target_cpu = ctx.attr.target_arch,
        target_libc = "unknown",
        compiler = "gcc",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    # You can alternatively define attributes here that make it possible to
    # instantiate different cc_toolchain_config targets with different behavior.
    attrs = {
        "flavor": attr.string(),
        "host_arch": attr.string(mandatory = True),
        "soctype": attr.string(),
        "target_arch": attr.string(mandatory = True),
    },
    provides = [CcToolchainConfigInfo],
)
