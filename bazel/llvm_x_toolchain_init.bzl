load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
load("@rules_cuda//cuda:dependencies.bzl", "rules_cuda_dependencies")

def llvm_x_toolchain_init():
    bazel_skylib_workspace()
    rules_cuda_dependencies(with_rules_cc = False)

    # Since rules_cc depends only on bazel_skylib, and we have added bazel_skylib
    # dependency before this function got chance to run, we comment out the following
    # line. Ref https://github.com/bazelbuild/rules_cc/blob/main/cc/repositories.bzl.
    # rules_cc_dependencies()
