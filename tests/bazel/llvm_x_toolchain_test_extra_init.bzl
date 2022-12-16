load("@rules_fuzzing//fuzzing:init.bzl", "rules_fuzzing_init")

def llvm_x_toolchain_test_extra_init():
    rules_fuzzing_init()
