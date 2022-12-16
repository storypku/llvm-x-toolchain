load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repo():
    http_archive(
        name = "rules_fuzzing",
        sha256 = "d9002dd3cd6437017f08593124fdd1b13b3473c7b929ceb0e60d317cb9346118",
        strip_prefix = "rules_fuzzing-0.3.2",
        urls = ["https://github.com/bazelbuild/rules_fuzzing/archive/v0.3.2.zip"],
    )
