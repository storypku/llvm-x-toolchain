load("@rules_cc//cc:defs.bzl", "cc_binary")

package(default_visibility = ["//visibility:public"])

cc_binary(
    name = "hello",
    srcs = ["hello.cc"],
)

cc_binary(
    name = "tcmalloc_hello",
    srcs = ["hello.cc"],
    malloc = "@com_google_tcmalloc//tcmalloc",
)
