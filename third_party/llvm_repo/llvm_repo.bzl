_LLVM_DIST_BASE_URL = "https://github.com/llvm/llvm-project/releases/download/llvmorg-"
_QCRAFT_OSS_BASE_URL = "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/"

_DEFAULT_SYSTEM_LLVM_DIR = "/opt/llvm"
_CRAFTED_PREFIX_DIR = "llvm"

def _arch(rctx):
    return rctx.execute(["uname", "-m"]).stdout.strip()

def _download_prebuilt_llvm_dist(arch, llvm_version, rctx):
    urls, sha256, strip_prefix = _llvm_dist_urls(arch, llvm_version)

    rctx.download_and_extract(
        urls,
        output = _CRAFTED_PREFIX_DIR,
        sha256 = sha256,
        stripPrefix = strip_prefix,
    )

def _llvm_dist_urls(arch, llvm_version):
    llvm_dists = {
        "aarch64-13.0.1": [
            "clang+llvm-13.0.1-aarch64-linux-gnu.tar.xz",
            "15ff2db12683e69e552b6668f7ca49edaa01ce32cb1cbc8f8ed2e887ab291069",
        ],
        "aarch64-14.0.0": [
            "clang+llvm-14.0.0-aarch64-linux-gnu.tar.xz",
            "1792badcd44066c79148ffeb1746058422cc9d838462be07e3cb19a4b724a1ee",
        ],
        "aarch64-15.0.6": [
            "clang+llvm-15.0.6-aarch64-linux-gnu.tar.xz",
            "8ca4d68cf103da8331ca3f35fe23d940c1b78fb7f0d4763c1c059e352f5d1bec",
        ],
        "x86_64-13.0.1": [
            "clang+llvm-13.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz",
            "84a54c69781ad90615d1b0276a83ff87daaeded99fbc64457c350679df7b4ff0",
        ],
        "x86_64-14.0.0": [
            "clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz",
            "61582215dafafb7b576ea30cc136be92c877ba1f1c31ddbbd372d6d65622fef5",
        ],
        "x86_64-15.0.6": [
            "clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04.tar.xz",
            "38bc7f5563642e73e69ac5626724e206d6d539fbef653541b34cae0ba9c3f036",
        ],
    }
    key = "{}-{}".format(arch, llvm_version)
    if key not in llvm_dists:
        fail("Unknown arch-version index:{}".format(key))

    basename, sha256 = llvm_dists[key]

    urls = _llvm_mirror_urls(basename, llvm_version)
    strip_prefix = basename[:(len(basename) - len(".tar.xz"))]
    return urls, sha256, strip_prefix

def _llvm_mirror_urls(basename, llvm_version):
    basename = basename.replace("+", "%2B")
    urls = [
        "{}{}".format(_QCRAFT_OSS_BASE_URL, basename),
        "{}{}/{}".format(_LLVM_DIST_BASE_URL, llvm_version, basename),
    ]
    return urls

def _check_host_os(rctx):
    os_name = rctx.os.name.lower()
    if os_name != "linux":
        fail("@{} was tailed to work only on Linux!".format(rctx.name))

def _write_top_level_build_file(rctx):
    rctx.template(
        "BUILD.bazel",
        Label("//third_party/llvm_repo:llvm_repo.BUILD.tpl"),
        substitutions = {"%{prefix}": _CRAFTED_PREFIX_DIR + "/"},
        executable = False,
    )

def _write_top_level_defs_bzl(arch, llvm_version, llvm_dir, rctx):
    rctx.template(
        "defs.bzl",
        Label("//third_party/llvm_repo:defs.bzl.tpl"),
        substitutions = {
            "%{arch}": arch,
            "%{llvm_dir}": llvm_dir,
            "%{llvm_dist_prefix}": _CRAFTED_PREFIX_DIR,
            "%{llvm_version}": llvm_version,
        },
        executable = False,
    )

def remote_llvm_repo_impl(rctx):
    _check_host_os(rctx)

    arch = _arch(rctx)
    llvm_version = rctx.attr.llvm_version

    _write_top_level_defs_bzl(arch, llvm_version, "", rctx)

    _write_top_level_build_file(rctx)

    _download_prebuilt_llvm_dist(arch, llvm_version, rctx)

remote_llvm_repo = repository_rule(
    attrs = {
        "llvm_version": attr.string(mandatory = True),
    },
    local = False,
    implementation = remote_llvm_repo_impl,
)

def local_llvm_repo_impl(rctx):
    _check_host_os(rctx)

    llvm_dir = rctx.attr.llvm_dir
    if not llvm_dir:
        llvm_dir = rctx.os.environ.get("LLVM_DIR", _DEFAULT_SYSTEM_LLVM_DIR)

    llvm_version = rctx.attr.llvm_version
    arch = _arch(rctx)

    rctx.symlink(llvm_dir, "llvm")
    _write_top_level_build_file(rctx)

    _write_top_level_defs_bzl(arch, llvm_version, llvm_dir, rctx)

local_llvm_repo = repository_rule(
    attrs = {
        "llvm_dir": attr.string(),
        "llvm_version": attr.string(mandatory = True),
    },
    local = True,
    environ = ["LLVM_DIR"],
    configure = True,
    implementation = local_llvm_repo_impl,
)
