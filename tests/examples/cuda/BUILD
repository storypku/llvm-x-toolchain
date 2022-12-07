load("@rules_cc//cc:defs.bzl", "cc_binary")
load("//bazel:rules_cuda.bzl", "cuda_binary", "cuda_library")

package(default_visibility = ["//visibility:public"])

cuda_library(
    name = "kernel",
    srcs = ["kernel.cu"],
    hdrs = ["kernel.h"],
)

# Run with 'bazel run --config=gpu //examples/cuda:hello_cuda'
cc_binary(
    name = "hello_cuda",
    srcs = ["hello_cuda.cc"],
    deps = [
        ":kernel",
    ],
)

cuda_library(
    name = "vec_add_lib",
    srcs = ["vec_add.cu"],
    visibility = ["//visibility:private"],
)

cuda_binary(
    name = "vec_add",
    deps = [
        ":vec_add_lib",
    ],
)

cuda_binary(
    name = "deviceQuery",
    srcs = ["deviceQuery.cpp"],
)

