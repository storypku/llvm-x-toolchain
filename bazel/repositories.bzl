load("//third_party/bazel_skylib:workspace.bzl", bazel_skylib = "repo")
load("//third_party/llvm_repo:workspace.bzl", llvm_repo = "repo")
load("//third_party/rules_cc:workspace.bzl", rules_cc = "repo")
load("//third_party/rules_cuda:workspace.bzl", rules_cuda = "repo")

def llvm_x_toolchain_repositories(use_local_llvm = True, llvm_version = None, llvm_dir = None):
    bazel_skylib()
    rules_cc()
    rules_cuda()

    llvm_repo(use_local = use_local_llvm, llvm_version = llvm_version, llvm_dir = llvm_dir)
