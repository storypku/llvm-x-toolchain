load("@rules_cc//cc:defs.bzl", "cc_test")

package(default_visibility = ["//visibility:public"])

cc_test(
    name = "omp_test",
    srcs = ["omp_test.c"],
    copts = ["-fopenmp"],
    linkopts = ["-fopenmp"],
    linkstatic = 1,
    deps = ["@llvm_toolchain//:omp"],
)
