load("@llvm_repo//:defs.bzl", llvm_dist = "llvm")
load(
    "//toolchain/internal:common.bzl",
    _arch = "arch",
    _canonical_dir_path = "canonical_dir_path",
    _check_os_arch_keys = "check_os_arch_keys",
    _list_to_string = "list_to_string",
    _os_arch_pair = "os_arch_pair",
    _pkg_path_from_label = "pkg_path_from_label",
    _supported_targets = "SUPPORTED_TARGETS",
    _toolchain_tools = "toolchain_tools",
)
load(
    "//toolchain/internal:sysroot.bzl",
    _sysroot_path = "sysroot_path",
)

_ALIASED_LIBS = ["omp"]
_ALIASED_TOOLS = ["clang-format", "llvm-cov"]

# Gets a value from the dict for the target pair, falling back to an empty
# key, if present.  Bazel 4.* doesn't support nested starlark functions, so
# we cannot simplify _dict_value() by defining it as a nested function.
def _dict_value(d, target_pair, default = None):
    return d.get(target_pair, d.get("", default))

def _extra_compiler_deps_str(rctx, key):
    extra_compiler_deps = _dict_value(rctx.attr.extra_compiler_deps, key)
    if not extra_compiler_deps:
        return ""
    else:
        return "".join([
            """\n{}"{}",""".format(" " * 8, extra_dep)
            for extra_dep in extra_compiler_deps
        ])

def llvm_config_impl(rctx):
    _check_os_arch_keys(rctx.attr.sysroot)
    _check_os_arch_keys(rctx.attr.cxx_builtin_include_directories)

    os = rctx.os.name
    arch = _arch(rctx)

    key = _os_arch_pair(os, arch)

    llvm_dist_label = Label("@llvm_repo//{}:BUILD.bazel".format(llvm_dist.prefix))
    llvm_dist_path_prefix = _pkg_path_from_label(llvm_dist_label) + "/"
    llvm_dist_rel_path = _canonical_dir_path("../../" + llvm_dist_path_prefix)
    llvm_dist_top_label_prefix = "@llvm_repo//:"
    llvm_dist_label_prefix = "{}{}/".format(llvm_dist_top_label_prefix, llvm_dist.prefix)

    # tools can only be defined as absolute paths or in a subdirectory of
    # config_repo_path, because their paths are relative to the package
    # defining cc_toolchain, and cannot contain '..'.
    # https://github.com/bazelbuild/bazel/issues/7746.  To work around
    # this, we symlink the needed tools under the package so that they (except
    # clang) can be called with normalized relative paths. For clang
    # however, using a path with symlinks interferes with the header file
    # inclusion validation checks, because clang frontend will infer the
    # InstalledDir to be the symlinked path, and will look for header files
    # in the symlinked path, but that seems to fail the inclusion
    # validation check. So we always use a cc_wrapper (which is called
    # through a normalized relative path), and then call clang with the not
    # symlinked path from the wrapper.
    wrapper_bin_prefix = "bin/"
    tools_path_prefix = "bin/"
    for tool_name in _toolchain_tools:
        rctx.symlink(llvm_dist_rel_path + "bin/" + tool_name, tools_path_prefix + tool_name)
    symlinked_tools_str = "".join([
        "\n" + (" " * 8) + "\"" + tools_path_prefix + name + "\","
        for name in _toolchain_tools
    ])

    workspace_name = rctx.name
    toolchain_info = struct(
        os = os,
        arch = arch,
        llvm_dist_top_label_prefix = llvm_dist_top_label_prefix,
        llvm_dist_label_prefix = llvm_dist_label_prefix,
        llvm_dist_path_prefix = llvm_dist_path_prefix,
        tools_path_prefix = tools_path_prefix,
        wrapper_bin_prefix = wrapper_bin_prefix,
        sysroot_dict = rctx.attr.sysroot,
        additional_include_dirs_dict = rctx.attr.cxx_builtin_include_directories,
        stdlib_dict = rctx.attr.stdlib,
        cxx_standard_dict = rctx.attr.cxx_standard,
        compile_flags_dict = rctx.attr.compile_flags,
        cxx_flags_dict = rctx.attr.cxx_flags,
        link_flags_dict = rctx.attr.link_flags,
        link_libs_dict = rctx.attr.link_libs,
        opt_compile_flags_dict = rctx.attr.opt_compile_flags,
        opt_link_flags_dict = rctx.attr.opt_link_flags,
        dbg_compile_flags_dict = rctx.attr.dbg_compile_flags,
        coverage_compile_flags_dict = rctx.attr.coverage_compile_flags,
        coverage_link_flags_dict = rctx.attr.coverage_link_flags,
        unfiltered_compile_flags_dict = rctx.attr.unfiltered_compile_flags,
        llvm_version = llvm_dist.llvm_version,
    )

    cc_toolchains_str, toolchain_labels_str = _cc_toolchains_str(
        workspace_name,
        toolchain_info,
    )

    convenience_targets_str = _convenience_targets_str(
        rctx,
        llvm_dist_rel_path,
        llvm_dist_label_prefix,
    )

    # Convenience macro to register all generated toolchains.
    rctx.template(
        "toolchains.bzl",
        Label("//toolchain:toolchains.bzl.tpl"),
        {
            "%{toolchain_labels}": toolchain_labels_str,
        },
    )

    # BUILD file with all the generated toolchain definitions.
    extra_compiler_deps_str = _extra_compiler_deps_str(rctx, key)
    rctx.template(
        "BUILD.bazel",
        Label("//toolchain:BUILD.toolchain.tpl"),
        {
            "%{cc_toolchain_config_bzl}": str(rctx.attr._cc_toolchain_config_bzl),
            "%{cc_toolchains}": cc_toolchains_str,
            "%{convenience_targets}": convenience_targets_str,
            "%{extra_compiler_deps}": extra_compiler_deps_str,
            "%{symlinked_tools}": symlinked_tools_str,
            "%{wrapper_bin_prefix}": wrapper_bin_prefix,
        },
    )

    # CC wrapper script; see comments near the definition of `wrapper_bin_prefix`.
    cc_wrapper_tpl = "//toolchain:cc_wrapper.sh.tpl"
    rctx.template(
        "bin/cc_wrapper.sh",
        Label(cc_wrapper_tpl),
        {
            "%{toolchain_path_prefix}": llvm_dist_path_prefix,
        },
    )

def _cc_toolchains_str(
        workspace_name,
        toolchain_info):
    # Since all the toolchains rely on downloading the right LLVM toolchain for
    # the host architecture, we don't need to explicitly specify
    # `exec_compatible_with` attribute. If the host and execution platform are
    # not the same, then host auto-detection based LLVM download does not work
    # and the user has to explicitly specify the distribution of LLVM they
    # want.

    # Note that for cross-compiling, the toolchain configuration will need
    # appropriate sysroots. A recommended approach is to configure two
    # `llvm_toolchain` repos, one without sysroots (for easy single platform
    # builds) and register this one, and one with sysroots and provide
    # `--extra_toolchains` flag when cross-compiling.

    cc_toolchains_str = ""
    toolchain_names = []
    for (target_os, target_arch) in _supported_targets:
        suffix = "{}-{}".format(target_arch, target_os)
        cc_toolchain_str = _cc_toolchain_str(
            workspace_name,
            suffix,
            target_os,
            target_arch,
            toolchain_info,
        )
        if cc_toolchain_str:
            cc_toolchains_str = cc_toolchains_str + cc_toolchain_str
            toolchain_name = "@{}//:cc-toolchain-{}".format(workspace_name, suffix)
            toolchain_names.append(toolchain_name)

    sep = ",\n" + " " * 8  # 2 tabs with tabstop=4.
    toolchain_labels_str = sep.join(["\"{}\"".format(d) for d in toolchain_names])
    return cc_toolchains_str, toolchain_labels_str

def _cc_toolchain_str(
        workspace_name,
        suffix,
        target_os,
        target_arch,
        toolchain_info):
    host_os = toolchain_info.os
    host_arch = toolchain_info.arch

    sysroot_path, sysroot = _sysroot_path(
        toolchain_info.sysroot_dict,
        target_os,
        target_arch,
    )
    if not sysroot_path:
        if host_arch != target_arch:
            # We are trying to cross-compile without a sysroot, let's bail.
            # TODO: Are there situations where we can continue?
            return ""
        else:
            sysroot_path = ""

    sysroot_label_str = "\"%s\"" % str(sysroot) if sysroot else ""

    extra_files_str = "\n{}\":internal-use-files\",".format(8 * " ")

    target_pair = _os_arch_pair(target_os, target_arch)

    template = """
# CC toolchain for cc-clang-{suffix}.

cc_toolchain_config(
    name = "local-{suffix}",
    host_arch = "{host_arch}",
    target_arch = "{target_arch}",
    toolchain_path_prefix = "{llvm_dist_path_prefix}",
    tools_path_prefix = "{tools_path_prefix}",
    wrapper_bin_prefix = "{wrapper_bin_prefix}",
    workspace_name = "{workspace_name}",
    compiler_configuration = {{
      "additional_include_dirs": {additional_include_dirs},
      "sysroot_path": "{sysroot_path}",
      "stdlib": "{stdlib}",
      "cxx_standard": "{cxx_standard}",
      "compile_flags": {compile_flags},
      "cxx_flags": {cxx_flags},
      "link_flags": {link_flags},
      "link_libs": {link_libs},
      "opt_compile_flags": {opt_compile_flags},
      "opt_link_flags": {opt_link_flags},
      "dbg_compile_flags": {dbg_compile_flags},
      "coverage_compile_flags": {coverage_compile_flags},
      "coverage_link_flags": {coverage_link_flags},
      "unfiltered_compile_flags": {unfiltered_compile_flags},
    }},
    llvm_version = "{llvm_version}",
)

toolchain(
    name = "cc-toolchain-{suffix}",
    exec_compatible_with = [
        "@platforms//cpu:{host_arch}",
        "@platforms//os:linux",
    ],
    target_compatible_with = [
        "@platforms//cpu:{target_arch}",
        "@platforms//os:linux",
    ],
    toolchain = ":cc-clang-{suffix}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
"""

    template = template + """
filegroup(
    name = "sysroot-components-{suffix}",
    srcs = [{sysroot_label_str}],
)

filegroup(
    name = "compiler-components-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}clang",
        "{llvm_dist_top_label_prefix}include",
        ":sysroot-components-{suffix}",
    ],
)

filegroup(
    name = "linker-components-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}clang",
        "{llvm_dist_top_label_prefix}ld",
        "{llvm_dist_top_label_prefix}ar",
        "{llvm_dist_top_label_prefix}lib",
        ":sysroot-components-{suffix}",
    ],
)

filegroup(
    name = "all-components-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}bin",
        ":compiler-components-{suffix}",
        ":linker-components-{suffix}",
    ],
)

filegroup(
    name = "all-files-{suffix}",
    srcs = [
        ":all-components-{suffix}",{extra_files_str}
    ],
)

filegroup(
    name = "archiver-files-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}ar",{extra_files_str}
    ],
)

filegroup(
    name = "assembler-files-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}as",{extra_files_str}
    ],
)

filegroup(
    name = "compiler-files-{suffix}",
    srcs = [
        ":compiler-components-{suffix}",{extra_files_str}
    ],
)

filegroup(
    name = "dwp-files-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}dwp",{extra_files_str}
    ],
)

filegroup(
    name = "linker-files-{suffix}",
    srcs = [
        ":linker-components-{suffix}",{extra_files_str}
    ],
)

filegroup(
    name = "objcopy-files-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}objcopy",{extra_files_str}
    ],
)

filegroup(
    name = "strip-files-{suffix}",
    srcs = [
        "{llvm_dist_top_label_prefix}strip",{extra_files_str}
    ],
)

cc_toolchain(
    name = "cc-clang-{suffix}",
    all_files = "all-files-{suffix}",
    ar_files = "archiver-files-{suffix}",
    as_files = "assembler-files-{suffix}",
    compiler_files = "compiler-files-{suffix}",
    dwp_files = "dwp-files-{suffix}",
    linker_files = "linker-files-{suffix}",
    objcopy_files = "objcopy-files-{suffix}",
    strip_files = "strip-files-{suffix}",
    toolchain_config = "local-{suffix}",
)
"""

    return template.format(
        suffix = suffix,
        target_arch = target_arch,
        host_arch = host_arch,
        llvm_dist_top_label_prefix = toolchain_info.llvm_dist_top_label_prefix,
        llvm_dist_label_prefix = toolchain_info.llvm_dist_label_prefix,
        llvm_dist_path_prefix = toolchain_info.llvm_dist_path_prefix,
        tools_path_prefix = toolchain_info.tools_path_prefix,
        wrapper_bin_prefix = toolchain_info.wrapper_bin_prefix,
        workspace_name = workspace_name,
        sysroot_label_str = sysroot_label_str,
        sysroot_path = sysroot_path,
        additional_include_dirs = _list_to_string(toolchain_info.additional_include_dirs_dict.get(target_pair, [])),
        stdlib = _dict_value(toolchain_info.stdlib_dict, target_pair, "builtin-libc++"),
        cxx_standard = _dict_value(toolchain_info.cxx_standard_dict, target_pair, "c++17"),
        compile_flags = _list_to_string(_dict_value(toolchain_info.compile_flags_dict, target_pair)),
        cxx_flags = _list_to_string(_dict_value(toolchain_info.cxx_flags_dict, target_pair)),
        link_flags = _list_to_string(_dict_value(toolchain_info.link_flags_dict, target_pair)),
        link_libs = _list_to_string(_dict_value(toolchain_info.link_libs_dict, target_pair)),
        opt_compile_flags = _list_to_string(_dict_value(toolchain_info.opt_compile_flags_dict, target_pair)),
        opt_link_flags = _list_to_string(_dict_value(toolchain_info.opt_link_flags_dict, target_pair)),
        dbg_compile_flags = _list_to_string(_dict_value(toolchain_info.dbg_compile_flags_dict, target_pair)),
        coverage_compile_flags = _list_to_string(_dict_value(toolchain_info.coverage_compile_flags_dict, target_pair)),
        coverage_link_flags = _list_to_string(_dict_value(toolchain_info.coverage_link_flags_dict, target_pair)),
        unfiltered_compile_flags = _list_to_string(_dict_value(toolchain_info.unfiltered_compile_flags_dict, target_pair)),
        llvm_version = toolchain_info.llvm_version,
        extra_files_str = extra_files_str,
    )

def _convenience_targets_str(rctx, llvm_dist_rel_path, llvm_dist_label_prefix):
    lib_target_strs = []
    for name in _ALIASED_LIBS:
        template = """
cc_import(
    name = "{name}",
    shared_library = "{{llvm_dist_label_prefix}}lib/lib{name}.so",
)""".format(name = name)
        lib_target_strs.append(template)

    tool_target_strs = []
    for name in _ALIASED_TOOLS:
        template = """
alias(
    name = "{name}",
    actual = "{{llvm_dist_label_prefix}}bin/{name}",
)""".format(name = name)
        tool_target_strs.append(template)

    return "\n".join(lib_target_strs + tool_target_strs).format(
        llvm_dist_label_prefix = llvm_dist_label_prefix,
    )
