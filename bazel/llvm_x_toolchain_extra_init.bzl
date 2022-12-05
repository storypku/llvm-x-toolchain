load("@rules_cc//cc:repositories.bzl", "rules_cc_toolchains")

def llvm_x_toolchain_extra_init():
    rules_cc_toolchains()
