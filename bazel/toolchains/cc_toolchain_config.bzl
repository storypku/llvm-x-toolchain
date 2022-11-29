"""
https://docs.bazel.build/versions/main/cc-toolchain-config-reference.html and
https://docs.bazel.build/versions/main/tutorial/cc-toolchain-config.html
"""

load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "tool_path")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")

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

cc_toolchain_config_rule = rule(
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

def cc_toolchain_config(
        toolchain_id,
        host_arch,
        target_arch,
        soctype = "",
        flavor = ""):
    toolchain_config_name = "{}_toolchain_config".format(toolchain_id)
    cc_toolchain_config_rule(
        name = toolchain_config_name,
        host_arch = host_arch,
        target_arch = target_arch,
        soctype = soctype,
        flavor = flavor,
    )
    cc_toolchain_name = "{}_cc_toolchain".format(toolchain_id)
    cc_toolchain(
        name = cc_toolchain_name,
        all_files = ":toolchain_files",
        ar_files = ":toolchain_files",
        compiler_files = ":toolchain_files",
        dwp_files = ":toolchain_files",
        linker_files = ":toolchain_files",
        objcopy_files = ":toolchain_files",
        strip_files = ":toolchain_files",
        toolchain_config = ":{}".format(toolchain_config_name),
    )
