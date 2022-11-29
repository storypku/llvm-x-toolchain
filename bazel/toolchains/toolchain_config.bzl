load(":cc_toolchain_config.bzl", "cc_toolchain_config")

_NATIVE_BUILD_ENTRIES = [
    ("x86_64", "x86_64", "", ""),
    ("x86_64", "x86_64", "", "asan"),
    ("aarch64", "aarch64", "xavier", ""),
    ("aarch64", "aarch64", "", ""),
]

_CROSS_BUILD_ENTRIES = [
    ("x86_64", "aarch64", "j5", ""),
    ("x86_64", "aarch64", "xavier", ""),
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
    for (host_arch, target_arch, soctype, flavor) in _NATIVE_BUILD_ENTRIES + _CROSS_BUILD_ENTRIES:
        toolchain_id = _name_prefix(host_arch, target_arch, soctype, flavor)
        toolchain_config_name = "{}_toolchain_config".format(toolchain_id)
        cc_toolchain_config(
            toolchain_id,
            host_arch,
            target_arch,
            soctype = soctype,
            flavor = flavor,
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
            name = "{}_toolchain".format(toolchain_id),
            exec_compatible_with = [
                "@platforms//cpu:{}".format(host_arch),
                "@platforms//os:linux",
            ],
            target_compatible_with = target_compatible_with,
            toolchain = ":{}_cc_toolchain".format(toolchain_id),
            toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        )

def register_my_toolchains():
    toolchains = []
    for (host_arch, target_arch, soctype, flavor) in _NATIVE_BUILD_ENTRIES:
        toolchain_id = _name_prefix(host_arch, target_arch, soctype, flavor)
        toolchains.append("//bazel/toolchains:{}_toolchain".format(toolchain_id))
    native.register_toolchains(*toolchains)
