load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

# FIXME(storypku):
# 1. bump rules_cc to 0.0.4 will cause bazel coverage to fail with the following error:
#
# ERROR: external/bazel_tools/tools/cpp/BUILD:63:11: in cc_library rule @bazel_tools//tools/cpp:malloc:
#   Symbol profile is provided by all of the following features: coverage gcc_coverage_map_format
# ERROR: external/bazel_tools/tools/cpp/BUILD:63:11:
#   Analysis of target '@bazel_tools//tools/cpp:malloc' failed
def repo():
    if native.existing_rule("rules_cc"):
        print("Found existing repo named 'rules_cc'. Unable to patch feature 'cuda'.")
        return

    git_rev = "081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e"  # Nov 11. 2021
    http_archive(
        name = "rules_cc",
        strip_prefix = "rules_cc-{}".format(git_rev),
        sha256 = "ff7876d80cd3f6b8c7a064bd9aa42a78e02096544cca2b22a9cf390a4397a53e",
        urls = [
            "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/rules_cc-{}.tar.gz".format(git_rev),
            "https://github.com/bazelbuild/rules_cc/archive/{}.tar.gz".format(git_rev),
        ],
        patches = [
            clean_dep("//third_party/rules_cc:p01_feature_cuda.patch"),
            clean_dep("//third_party/rules_cc:p02_builtin_sysroot.patch"),
        ],
    )
