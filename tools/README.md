
## What is different among different unix `cc_toolchain_config` rules ?

You can run the following command to view the full diff.
```
bash cc_diff.sh
```

### Attributes
Currently, `cc_toolchain_config` rule from bazel.git have the following attributes
 which are missing from its counterpart in `rules_cc.git`.

```
"conly_flags": attr.string_list(),
"archive_flags": attr.string_list(),
"builtin_sysroot": attr.string(),
```

### Features
https://bazel.build/docs/cc-toolchain-config-reference#features

## How to generate `builtin_include_directory_paths`

1. Add the following to the very bottom of the WORKSPACE file

```
load("@bazel_tools//tools/cpp:cc_configure.bzl", "cc_configure")
cc_configure()
```

3. Run `bazel build //path/to/some:target --action_env=CC=/opt/llvm/bin/clang`

4. Create symlink if not exists

```
ln -s bazel-out/../../../external external
```

5. And you will see the generated `builtin_include_directory_paths` in `external/local_config_cc`

## References
- https://github.com/bazelbuild/bazel/blob/master/tools/cpp/cc_configure.bzl
- https://github.com/envoyproxy/envoy-build-tools/blob/main/toolchains/configs/linux/clang/cc/BUILD


