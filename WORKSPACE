workspace(name = "llvm_x_toolchain")

load("//bazel:repositories.bzl", "llvm_x_toolchain_repositories")

llvm_x_toolchain_repositories()

load("//bazel:llvm_x_toolchain_init.bzl", "llvm_x_toolchain_init")

llvm_x_toolchain_init()

load("//bazel:llvm_x_toolchain_extra_init.bzl", "llvm_x_toolchain_extra_init")

llvm_x_toolchain_extra_init()

load("//third_party/llvm_repo:workspace.bzl", llvm_repo = "repo")

llvm_repo()

load("//bazel/toolchains:toolchain_config.bzl", "register_my_toolchains")

register_my_toolchains()
