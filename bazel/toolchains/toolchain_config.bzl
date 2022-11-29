load("@rules_cc//cc:defs.bzl", "cc_toolchain")
load(":cc_toolchain_config.bzl", "cc_toolchain_config")

_SUPPORTED_COMBINATIONS = [
    ("x86_64", "x86_64", "", ""),
    ("x86_64", "x86_64", "", "asan"),
    ("x86_64", "aarch64", "j5", ""),
    ("x86_64", "aarch64", "xavier", ""),
    ("aarch64", "aarch64", "xavier", ""),
    ("aarch64", "aarch64", "", ""),
]

def _name_prefix(host_arch, target_arch, soctype = "", flavor = ""):
    if host_arch != target_arch:
        if flavor:
            return "{}_{}_cross".format(soctype, flavor)
        else:
            return "{}_cross".format(soctype)
    else:  # Native
        if soctype:
            return "{}_{}".format(soctype, flavor) if flavor else soctype
        else:
            return "{}_{}".format(target_arch, flavor) if flavor else target_arch

def define_my_toolchains():
    for (host_arch, target_arch, soctype, flavor) in _SUPPORTED_COMBINATIONS:
        tag_id = _name_prefix(host_arch, target_arch, soctype, flavor)
        toolchain_config_name = "{}_toolchain_config".format(tag_id)
        cc_toolchain_config(
            name = toolchain_config_name,
            host_arch = host_arch,
            soctype = soctype,
            flavor = flavor,
            target_arch = target_arch,
        )
        cc_toolchain_name = "{}_cc_toolchain".format(tag_id)
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
        target_compatible_with = [
            "@platforms//cpu:{}".format(target_arch),
            "@platforms//os:linux",
        ]
        if soctype:
            target_compatible_with.append(
                "//bazel/soctype:{}".format(soctype),
            )
        if flavor:
            target_compatible_with.append(
                "//bazel/flavor:{}".format(flavor),
            )

        native.toolchain(
            name = "{}_toolchain".format(tag_id),
            exec_compatible_with = [
                "@platforms//cpu:{}".format(host_arch),
                "@platforms//os:linux",
            ],
            target_compatible_with = target_compatible_with,
            toolchain = ":{}".format(cc_toolchain_name),
            toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        )
