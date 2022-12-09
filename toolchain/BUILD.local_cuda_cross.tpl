package(default_visibility = ["//visibility:public"])

filegroup(
    name = "_cuda_header_files",
    srcs = glob(["cuda/include/**"]),
    visibility = ["//visibility:private"],
)

cc_library(
    name = "cuda_headers",
    hdrs = [":_cuda_header_files"],
    includes = ["cuda/include"],
)

# Note: do not use this target directly, use the configurable label_flag
# @rules_cuda//cuda:cuda_runtime instead.
cc_library(
    name = "cuda_runtime",
    srcs = glob(["cuda/%{libdir}/libcudart.so.*"]),
    hdrs = [":_cuda_header_files"],
    includes = ["cuda/include"],
    linkopts = [
        "-ldl",
        "-lpthread",
        "-lrt",
    ],
    visibility = ["@rules_cuda//cuda:__pkg__"],
)

# Note: do not use this target directly, use the configurable label_flag
# @rules_cuda//cuda:cuda_runtime instead.
cc_library(
    name = "cuda_runtime_static",
    srcs = ["cuda/%{libdir}/libcudart_static.a"],
    hdrs = [":_cuda_header_files"],
    includes = ["cuda/include"],
    linkopts = [
        "-ldl",
        "-lpthread",
        "-lrt",
    ],
    visibility = ["@rules_cuda//cuda:__pkg__"],
)
