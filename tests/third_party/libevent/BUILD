load("@rules_cc//cc:defs.bzl", "cc_binary")

package(default_visibility = ["//visibility:public"])

exports_files([
    "libevent.BUILD",
])

cc_binary(
    name = "hello",
    srcs = ["hello.c"],
    linkstatic = True,
    deps = [
        "@com_github_libevent_libevent//:libevent",
    ],
)
