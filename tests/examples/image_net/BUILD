load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")
load("//bazel:common.bzl", "if_cuda")
load("//bazel:rules_cuda.bzl", "cuda_library")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "image_net_base",
    hdrs = ["image_net_base.h"],
)

cc_library(
    name = "common_flags",
    srcs = ["common_flags.cc"],
    hdrs = ["common_flags.h"],
    deps = [
        "@com_github_gflags_gflags//:gflags",
    ],
)

cc_library(
    name = "image_net_cpu",
    srcs = ["image_net_cpu.cc"],
    hdrs = ["image_net_cpu.h"],
    deps = [
        ":image_net_base",
    ],
)

cuda_library(
    name = "image_net_gpu",
    srcs = ["image_net_gpu.cu"],
    hdrs = ["image_net_gpu.h"],
    deps = [
        ":image_net_base",
    ],
)

cc_library(
    name = "image_net",
    srcs = ["image_net.cc"],
    hdrs = ["image_net.h"],
    deps = [
        ":common_flags",
        ":image_net_cpu",
    ] + if_cuda([
        ":image_net_gpu",
    ]),
)

## ============= Executables ================= ##
cc_binary(
    name = "image_net_gpu_demo",
    srcs = ["image_net_gpu_demo.cc"],
    deps = [
        ":image_net_gpu",
        "@com_github_gflags_gflags//:gflags",
    ],
)

cc_binary(
    name = "image_net_demo",
    srcs = ["image_net_demo.cc"],
    deps = [
        ":image_net",
        "@com_github_gflags_gflags//:gflags",
    ],
)
