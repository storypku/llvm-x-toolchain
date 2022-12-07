load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

def repo():
    if native.existing_rule("rules_cc"):
        print("Found existing repo named 'rules_cc'. Unable to patch feature 'cuda'.")
        return

    version = "0.0.4"
    http_archive(
        name = "rules_cc",
        strip_prefix = "rules_cc-{}".format(version),
        sha256 = "af6cc82d87db94585bceeda2561cb8a9d55ad435318ccb4ddfee18a43580fb5d",
        urls = [
            "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/rules_cc-{}.tar.gz".format(version),
            "https://github.com/bazelbuild/rules_cc/archive/{}.tar.gz".format(version),
        ],
        patch_args = ["-p1"],
        patches = [
            clean_dep("//third_party/rules_cc:p01_builtin_sysroot.patch"),
            clean_dep("//third_party/rules_cc:p02_feature_cuda.patch"),
            clean_dep("//third_party/rules_cc:p03_nvcc_host_compiler.patch"),
        ],
    )
