load("//third_party/bazel_skylib:workspace.bzl", bazel_skylib = "repo")
load("//third_party/rules_cc:workspace.bzl", rules_cc = "repo")
load("//third_party/rules_cuda:workspace.bzl", rules_cuda = "repo")

def llvm_x_toolchain_repositories():
    bazel_skylib()
    rules_cc()
    rules_cuda()
