load("//third_party/absl:workspace.bzl", absl = "repo")
load("//third_party/gflags:workspace.bzl", gflags = "repo")
load("//third_party/glog:workspace.bzl", glog = "repo")
load("//third_party/googletest:workspace.bzl", googletest = "repo")
load("//third_party/libevent:workspace.bzl", libevent = "repo")
load("//third_party/openssl:workspace.bzl", openssl = "repo")
load("//third_party/rules_foreign_cc:workspace.bzl", rules_foreign_cc = "repo")
load("//third_party/x_compil_sysroots:workspace.bzl", x_compil_sysroots = "repo")

def llvm_x_toolchain_test_repositories():
    rules_foreign_cc()
    x_compil_sysroots()

    absl()
    gflags()
    glog()
    googletest()
    openssl()
    libevent()
