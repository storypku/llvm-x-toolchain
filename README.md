# LLVM Toolchain for Bazel w/ Cross Compilation Support


## Building with the default toolchain

```
$ bazel clean
$ bazel build //:buildme
$ file bazel-bin//libbuildme.a
bazel-bin//libbuildme.a: current ar archive
```

## Custom toolchain with platforms

This mode requires `--incompatible_enable_cc_toolchain_resolution`. Without this
flag, `--platforms` and `--extra_toolchains` are ignored and the default
toolchain triggers.

```
$ bazel clean
$ bazel build //:buildme --platforms=//:x86_platform --extra_toolchains=//:platform_based_toolchain --incompatible_enable_cc_toolchain_resolution
DEBUG: /usr/local/google/home/gregce/bazel/rules_cc//toolchain_config.bzl:17:10: Invoking my custom toolchain!
INFO: From Compiling /buildme.cc:
bin/sample_compiler: running sample cc_library compiler (produces .o output).
INFO: From Linking /libbuildme.a:
bin/sample_linker: running sample cc_library linker (produces .a output).

$ cat bazel-bin//libbuildme.a
bin/sample_linker: sample output
```

This example uses a long command line for demonstration purposes. A real project
would [register toolchains](https://docs.bazel.build/versions/master/toolchains.html#registering-and-building-with-toolchains)
in `WORKSPACE` and auto-set
`--incompatible_enable_cc_toolchain_resolution`. That reduces the command to:

```
$ bazel build //:buildme --platforms=//:x86_platform
```

## Custom toolchain with legacy selection:

```
$ bazel clean
$ bazel build //:buildme --crosstool_top=//:legacy_selector --cpu=x86
DEBUG: /usr/local/google/home/gregce/bazel/rules_cc//toolchain_config.bzl:17:10: Invoking my custom toolchain!
INFO: From Compiling /buildme.cc:
bin/sample_compiler: running sample cc_library compiler (produces .o output).
INFO: From Linking /libbuildme.a:
bin/sample_linker: running sample cc_library linker (produces .a output).

$ cat bazel-bin//libbuildme.a
bin/sample_linker: sample output
```

