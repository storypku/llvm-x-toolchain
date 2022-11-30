load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_cc",
    sha256 = "af6cc82d87db94585bceeda2561cb8a9d55ad435318ccb4ddfee18a43580fb5d",
    strip_prefix = "rules_cc-0.0.4",
    urls = [
        "https://github.com/bazelbuild/rules_cc/releases/download/0.0.4/rules_cc-0.0.4.tar.gz",
    ],
)

load("//third_party/llvm_repo:workspace.bzl", llvm_repo = "repo")
llvm_repo(use_local = False)

load("//bazel/toolchains:toolchain_config.bzl", "register_my_toolchains")

register_my_toolchains()
