load(
    "//toolchain/internal:common.bzl",
    _os_arch_pair = "os_arch_pair",
    _pkg_path_from_label = "pkg_path_from_label",
)

# Return the sysroot path and the label to the files, if sysroot is not a system path.
def sysroot_path(sysroot_dict, os, arch):
    sysroot = sysroot_dict.get(_os_arch_pair(os, arch))
    if not sysroot:
        return (None, None)

    # If the sysroot is an absolute path, use it as-is. Check for things that
    # start with "/" and not "//" to identify absolute paths, but also support
    # passing the sysroot as "/" to indicate the root directory.
    if sysroot[0] == "/" and (len(sysroot) == 1 or sysroot[1] != "/"):
        return (sysroot, None)

    sysroot_path = _pkg_path_from_label(Label(sysroot))
    return (sysroot_path, sysroot)
