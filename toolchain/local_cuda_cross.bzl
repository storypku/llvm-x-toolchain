load("//toolchain/internal:common.bzl", _python = "python")

_CRAFTED_PREFIX_DIR = "sysroot_stub"

def _check_host_os(rctx):
    os_name = rctx.os.name.lower()
    if os_name != "linux":
        fail("@{} was tailed to work only on Linux!".format(rctx.name))

def _check_sysroot_dir(sysroot_dir, rctx):
    is_absolute = sysroot_dir and sysroot_dir[0] == "/" and \
                  (len(sysroot_dir) == 1 or sysroot_dir[1] != "/")
    if not is_absolute:
        print("sysroot_dir should be absolute path: {}".format(sysroot_dir))
    return rctx.path(sysroot_dir).exists

def _dirname(p):
    prefix, sep, _ = p.rpartition("/")
    return prefix.rstrip("/") if prefix else sep

def _basename(p):
    return p.rpartition("/")[-1]

def _write_build_file(rctx, cuda_x_inc_dir, cuda_x_lib_dir):
    cuda_x_dir = _dirname(cuda_x_inc_dir)
    rctx.symlink(cuda_x_dir, "cuda")

    rctx.template(
        "BUILD",
        Label("//toolchain:BUILD.local_cuda_cross.tpl"),
        substitutions = {
            "%{libdir}": _basename(cuda_x_lib_dir),
        },
        executable = False,
    )

def _find_cuda_cross(rctx, sysroot_dir):
    cuda_x_script = rctx.path(Label("//toolchain/internal:find_cuda_cross.py"))
    cuda_x_result = rctx.execute([
        _python(rctx),
        cuda_x_script,
        sysroot_dir,
        rctx.attr.arch,
    ])
    if cuda_x_result.return_code != 0:
        return (None, None)

    cuda_x_dict = dict()
    for line in cuda_x_result.stdout.rstrip().split("\n"):
        (k, v) = line.split(":")
        cuda_x_dict[k.strip()] = v.strip()

    cuda_x_inc_dir = cuda_x_dict.get("CUDA_X_INC", None)
    cuda_x_lib_dir = cuda_x_dict.get("CUDA_X_LIB", None)
    return (cuda_x_inc_dir, cuda_x_lib_dir)

def local_cuda_cross_impl(rctx):
    _check_host_os(rctx)

    sysroot_dir = rctx.attr.sysroot_dir.rstrip("/")
    if not _check_sysroot_dir(sysroot_dir, rctx):
        rctx.file("BUILD")  # Empty file
        return

    cuda_x_inc_dir, cuda_x_lib_dir = _find_cuda_cross(rctx, sysroot_dir)
    if not cuda_x_lib_dir or not cuda_x_inc_dir:
        rctx.file("BUILD")
        return

    _write_build_file(rctx, cuda_x_inc_dir, cuda_x_lib_dir)

local_cuda_cross = repository_rule(
    attrs = {
        "sysroot_dir": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
    environ = ["CUDA_X_PATH"],
    local = True,
    configure = True,
    implementation = local_cuda_cross_impl,
)
