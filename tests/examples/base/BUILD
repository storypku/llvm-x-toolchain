load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

cc_library(
    name = "sha256",
    srcs = ["sha256.cc"],
    hdrs = ["sha256.h"],
    deps = [
        "@com_google_absl//absl/status:statusor",
        "@com_google_absl//absl/strings:str_format",
        "@com_google_absl//absl/types:span",
        "@openssl//:ssl",
    ],
)

cc_test(
    name = "sha256_test",
    size = "small",
    srcs = ["sha256_test.cc"],
    linkstatic = True,
    deps = [
        ":sha256",
        "@com_google_googletest//:gtest",
        "@com_google_googletest//:gtest_main",
    ],
)
