load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

def repo():
    git_rev = "9cee484d9f9314c2a30d18bff02e5f240308ae5b"  # Latest as of Nov 2, 2022
    http_archive(
        name = "rules_cuda",
        strip_prefix = "runtime-{}/third_party/rules_cuda".format(git_rev),
        sha256 = "e21ec1005d908e0623fe8466ff561644b48cf3ab554a0a6a6bcbc173d37c7c5d",
        urls = [
            "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/tensorflow_runtime-{}.tar.gz".format(git_rev),
            "https://github.com/tensorflow/runtime/archive/{}.tar.gz".format(git_rev),
        ],
        patch_args = ["-p3"],
        patches = [
            clean_dep("//third_party/rules_cuda:p01_sm_86_support.patch"),
            clean_dep("//third_party/rules_cuda:p03_local_cuda_made_local.patch"),
        ],
    )
