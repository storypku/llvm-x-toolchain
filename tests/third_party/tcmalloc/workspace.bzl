load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repo():
    git_rev = "ea9a8a91564a489fb8b8536ac36b56e5e71fba05"
    http_archive(
        name = "com_google_tcmalloc",
        strip_prefix = "tcmalloc-{}".format(git_rev),
        urls = [
            "https://github.com/google/tcmalloc/archive/{}.tar.gz".format(git_rev),
        ],
    )
