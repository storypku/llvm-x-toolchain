load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

def repo():
    http_archive(
        name = "com_github_google_glog",
        strip_prefix = "glog-0.6.0",
        sha256 = "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6",
        build_file = clean_dep("//third_party/glog:glog.BUILD"),
        urls = [
            "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/glog-0.6.0.tar.gz",
            "https://github.com/google/glog/archive/v0.6.0.tar.gz",
        ],
    )
