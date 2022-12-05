load("//third_party/absl:workspace.bzl", absl = "repo")
load("//third_party/googletest:workspace.bzl", googletest = "repo")
load("//third_party/openssl:workspace.bzl", openssl = "repo")

def llvm_x_toolchain_test_deps():
    absl()
    googletest()
    openssl()
