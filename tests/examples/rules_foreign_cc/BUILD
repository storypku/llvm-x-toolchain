load("@rules_cc//cc:defs.bzl", "cc_binary")

package(default_visibility = ["//visibility:public"])

cc_binary(
    name = "example",
    srcs = ["example.c"],
    linkstatic = True,
    deps = [
        "@com_github_libevent_libevent//:libevent",
    ],
)
