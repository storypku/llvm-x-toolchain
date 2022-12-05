load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

OPENSSL_HEADERS = glob([
    "*.h",
])

cc_library(
    name = "crypto",
    hdrs = OPENSSL_HEADERS,
    include_prefix = "openssl",
    linkopts = ["-lcrypto"],
)

cc_library(
    name = "ssl",
    hdrs = OPENSSL_HEADERS,
    include_prefix = "openssl",
    linkopts = ["-lssl"],
    deps = [
        ":crypto",
    ],
)
