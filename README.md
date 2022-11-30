# LLVM Toolchain for Bazel w/ Cross Compilation Support


## Building with the default toolchain

```
$ bazel clean
$ bazel build //demo:buildme
$ file bazel-bin//demo/libbuildme.a
bazel-bin//libbuildme.a: current ar archive
```

## Custom toolchain with platforms

This mode requires `--incompatible_enable_cc_toolchain_resolution` (already set in `.bazelrc`).
 Without this flag, `--platforms` and `--extra_toolchains` are ignored and the default
toolchain triggers.

```
$ bazel clean
$ bazel build //demo:buildme --platforms=//:j5_cross_platform --extra_toolchains=//bazel/toolchains:j5_cross_toolchain
INFO: From Compiling demo/buildme.cc:
bazel/toolchains/bin/sample_compiler: running sample cc_library compiler (produces .o output).
INFO: From Linking demo/libbuildme.a:
bazel/toolchains/bin/sample_linker: running sample cc_library linker (produces .a output).

$ cat bazel-bin//demo/libbuildme.a
bazel/toolchains/bin/sample_linker: sample output
```
