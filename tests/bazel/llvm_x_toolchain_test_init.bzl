load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

def llvm_x_toolchain_test_init():
    rules_foreign_cc_dependencies()
