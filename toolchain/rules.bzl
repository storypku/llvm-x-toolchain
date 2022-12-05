load(
    "//toolchain/internal:common.bzl",
    _supported_os_arch_keys = "supported_os_arch_keys",
)
load(
    "//toolchain/internal:configure.bzl",
    _llvm_config_impl = "llvm_config_impl",
)

_target_pairs = ", ".join(_supported_os_arch_keys())

_compiler_configuration_attrs = {
    # For default values of all the below flags overrides, consult
    # cc_toolchain_config.bzl in this directory.
    "compile_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for compile_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "coverage_compile_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for coverage_compile_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "coverage_link_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for coverage_link_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "cxx_builtin_include_directories": attr.string_list_dict(
        mandatory = False,
        doc = ("Additional builtin include directories to be added to the default system " +
               "directories, for each target OS and arch pair you want to support " +
               "({}); ".format(_target_pairs) +
               "see documentation for bazel's create_cc_toolchain_config_info."),
    ),
    "cxx_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for cxx_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "cxx_standard": attr.string_dict(
        mandatory = False,
        doc = ("C++ standard, for each target OS and arch pair you want to support " +
               "({}), ".format(_target_pairs) +
               "passed as `-std` flag to the compiler. An empty key can be used to specify a " +
               "value for all target pairs. Default value is c++17."),
    ),
    "dbg_compile_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for dbg_compile_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "link_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for link_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "link_libs": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for link_libs, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "opt_compile_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for opt_compile_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "opt_link_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for opt_link_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
    "stdlib": attr.string_dict(
        mandatory = False,
        doc = ("stdlib implementation, for each target OS and arch pair you want to support " +
               "({}), ".format(_target_pairs) +
               "linked to the compiled binaries. An empty key can be used to specify a " +
               "value for all target pairs. Possible values are `builtin-libc++` (default) " +
               "which uses the libc++ shipped with clang, `libc++` which uses libc++ available on " +
               "the host or sysroot, `stdc++` which uses libstdc++ available on the host or " +
               "sysroot, and `none` which uses `-nostdlib` with the compiler."),
    ),
    "sysroot": attr.string_dict(
        mandatory = False,
        doc = ("System path or fileset, for each target OS and arch pair you want to support " +
               "({}), ".format(_target_pairs) +
               "used to indicate the set of files that form the sysroot for the compiler. " +
               "If the value begins with exactly one forward slash '/', then the value is " +
               "assumed to be a system path. Else, the value will be assumed to be a label " +
               "containing the files and the sysroot path will be taken as the path to the " +
               "package of this label."),
    ),
    "unfiltered_compile_flags": attr.string_list_dict(
        mandatory = False,
        doc = ("Override for unfiltered_compile_flags, replacing the default values. " +
               "`{toolchain_path_prefix}` in the flags will be substituted by the path " +
               "to the root LLVM distribution directory. Provide one list for each " +
               "target OS and arch pair you want to override " +
               "({}); empty key overrides all.".format(_target_pairs)),
    ),
}

_llvm_config_attrs = dict(_compiler_configuration_attrs)
_llvm_config_attrs.update(_compiler_configuration_attrs)
_llvm_config_attrs.update({
    "_cc_toolchain_config_bzl": attr.label(
        default = "//toolchain:cc_toolchain_config.bzl",
    ),
})

llvm_toolchain = repository_rule(
    attrs = _llvm_config_attrs,
    local = True,
    configure = True,
    implementation = _llvm_config_impl,
)

