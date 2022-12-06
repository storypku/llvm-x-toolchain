load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repo():
    version = "0.9.0"
    http_archive(
        name = "rules_foreign_cc",
        sha256 = "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
        strip_prefix = "rules_foreign_cc-{}".format(version),
        urls = [
            "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/rules_foreign_cc-{}.tar.gz".format(version),
            "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/{}.tar.gz".format(version),
        ],
    )
