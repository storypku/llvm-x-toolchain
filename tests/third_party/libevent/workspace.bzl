"""Loads the libevent library"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

def repo():
    http_archive(
        name = "com_github_libevent_libevent",
        build_file = clean_dep("//third_party/libevent:libevent.BUILD"),
        sha256 = "e864af41a336bb11dab1a23f32993afe963c1f69618bd9292b89ecf6904845b0",
        strip_prefix = "libevent-2.1.10-stable",
        urls = [
            "https://qcraft-web.oss-cn-beijing.aliyuncs.com/cache/packages/libevent-2.1.10-stable.tar.gz",
            "https://github.com/libevent/libevent/releases/download/release-2.1.10-stable/libevent-2.1.10-stable.tar.gz",
        ],
    )
