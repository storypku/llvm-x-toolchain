load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")
load("@rules_fuzzing//fuzzing:repositories.bzl", "rules_fuzzing_dependencies")

def llvm_x_toolchain_test_init():
    rules_foreign_cc_dependencies()

    rules_fuzzing_dependencies()
